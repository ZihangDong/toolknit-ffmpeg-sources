// SPDX-License-Identifier: MIT
// Copyright (c) 2026 Zihang Dong
import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { readFile } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';

const root = fileURLToPath(new URL('../', import.meta.url));
const run = args => execFileSync('git', args, { cwd: root, encoding: 'utf8', windowsHide: true }).trim();
const metadata = JSON.parse(await readFile(new URL('../metadata/runtime.json', import.meta.url), 'utf8'));
const tree = run(['rev-parse', 'HEAD:ffmpeg']);
assert.equal(tree, metadata.mainSource.tree, 'Preserved Git tree must equal the exact upstream tree.');
assert.equal(run(['status', '--porcelain', '--untracked-files=all', '--', 'ffmpeg/']), '',
  'The source checkout must have no modifications or extra files.');
const notice = await readFile(new URL('../upstream-build/README.gyan.txt', import.meta.url), 'utf8');
const version = await readFile(new URL('../upstream-build/ffmpeg-version.txt', import.meta.url), 'utf8');
assert.ok(notice.includes(metadata.mainSource.commit.slice(0, 10)), 'Upstream notice identifies the revision.');
assert.ok(version.includes(metadata.runtimeVersion), 'Captured output identifies the runtime.');
assert.ok(version.includes('--enable-gpl --enable-version3 --enable-static'));
console.log(`Verified source tree ${tree} (${metadata.mainSource.commit}).`);
console.log('Scope: main FFmpeg source only. See BUILD-SOURCE-STATUS.md for missing static-dependency materials.');
