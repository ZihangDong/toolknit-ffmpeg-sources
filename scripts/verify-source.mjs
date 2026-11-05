// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Zihang Dong
import assert from 'node:assert/strict';
import { createHash } from 'node:crypto';
import { execFileSync } from 'node:child_process';
import { access, readFile, readdir } from 'node:fs/promises';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const root = fileURLToPath(new URL('../', import.meta.url));
const read = p => readFile(path.join(root, p));
const json = async p => JSON.parse(await read(p));
const hash = data => createHash('sha256').update(data).digest('hex');
const metadata = await json('metadata/runtime.json');
const manifest = await json('metadata/build-sources.json');
assert.deepEqual(manifest.mainSource, metadata.mainSource);
assert.equal(manifest.profile, metadata.build.profile);
for (const source of manifest.sources) {
  const bytes = await read(source.file);
  assert.equal(bytes.length, source.bytes, source.name);
  assert.equal(hash(bytes), source.sha256, source.name);
}
const files = await json('metadata/main-source-files.json');
const directory = metadata.mainSource.directory;
for (const entry of files) {
  let bytes = await read(path.join(directory, entry.path));
  // This upstream text fixture explicitly uses eol=crlf in Git.
  if (entry.path === 'tests/ref/fate/sub-scc') bytes = Buffer.from(bytes.toString().replaceAll('\r\n', '\n'));
  assert.equal(hash(bytes), entry.sha256, entry.path);
}
async function listFiles(dir, prefix = '') {
  const names = [];
  for (const entry of await readdir(dir, { withFileTypes: true })) {
    const relative = prefix + entry.name;
    if (entry.isDirectory()) names.push(...await listFiles(path.join(dir, entry.name), relative + '/'));
    else { assert.ok(entry.isFile(), `Unexpected special file: ${relative}`); names.push(relative); }
  }
  return names;
}
assert.deepEqual((await listFiles(path.join(root, directory))).sort(), files.map(f => f.path).sort(),
  'Main source must contain exactly the recorded files.');
const hasGit = await access(path.join(root, '.git')).then(() => true, () => false);
if (hasGit) {
  const git = args => execFileSync('git', args, { cwd: root, encoding: 'utf8', windowsHide: true }).trim();
  assert.equal(git(['rev-parse', `HEAD:${directory}`]), metadata.mainSource.tree);
  assert.equal(git(['status', '--porcelain', '--untracked-files=all', '--', directory]), '');
}
const evidence = metadata.build.evidenceDirectory;
const identity = await json(`${evidence}/binary-identity.json`);
for (const key of ['bytes', 'sha256', 'exeBytes', 'exeSha256']) assert.equal(identity[key], metadata.binary[key], key);
assert.equal(identity.buildProfile, manifest.profile);
assert.ok((await read(`${evidence}/ffmpeg-version.txt`)).toString().includes(metadata.runtimeVersion));
const config = (await read(`${evidence}/ffmpeg-buildconf.txt`)).toString();
for (const flag of ['--enable-gpl', '--enable-version3', '--enable-static', '--disable-autodetect']) assert.ok(config.includes(flag));
for (const file of ['build/build-win64.sh', 'LICENSES/GPL-3.0.txt', 'LICENSES/Third-Party.txt',
  'LICENSES/Toolchain-Runtime.txt', 'validation/windows-runtime.json']) assert.ok((await read(file)).length);
console.log(`Verified ${files.length} FFmpeg files and ${manifest.sources.length} exact dependency archives.`);
console.log(`Runtime: ${metadata.runtimeVersion}; build and binary identity match preserved evidence.`);
console.log('Scope: selected ToolKnit profile. Legacy Gyan gaps remain documented separately.');
