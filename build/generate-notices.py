# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Zihang Dong
"""Preserve original notices from the exact archived dependency sources."""
import hashlib
import json
import tarfile
from pathlib import Path, PurePosixPath

root = Path(__file__).resolve().parent.parent
manifest = json.loads((root / 'metadata/build-sources.json').read_text())
parts = ['THIRD-PARTY NOTICES\n\nBuild toolknit-win64-6.1.6-r3. These notices do not change upstream licenses.\n'
         'Full source trees and per-file notices are preserved in the source archives.\n']
for source in manifest['sources']:
    archive = root / source['file']
    assert hashlib.sha256(archive.read_bytes()).hexdigest() == source['sha256']
    parts.append(f"\n\n===== {source['name']} =====\nSource: {source['url']}\nArchive SHA-256: {source['sha256']}\n")
    with tarfile.open(archive, 'r:gz') as tar:
        for entry in sorted(tar.getmembers(), key=lambda entry: entry.name):
            if not entry.isfile():
                continue
            relative = PurePosixPath(*PurePosixPath(entry.name).parts[1:])
            is_notice = relative.name.upper().startswith(('COPYING', 'LICENSE', 'COPYRIGHT', 'PATENTS', 'AUTHORS'))
            is_header = source['name'] == 'nv-codec-headers' and str(relative).startswith('include/ffnvcodec/') and relative.suffix == '.h'
            if not (is_notice or is_header):
                continue
            data = tar.extractfile(entry).read()
            try:
                text = data.decode('utf8')
            except UnicodeDecodeError:
                text = data.decode('latin1')
            if is_header:
                text = text[:text.index('*/') + 2]
            parts.append(f'\n--- {relative} ---\n{text}')
# Normalize whitespace in this reading copy; archives retain original bytes.
notice = '\n'.join(line.rstrip() for line in '\n'.join(parts).splitlines()).rstrip() + '\n'
(root / 'LICENSES/Third-Party.txt').write_text(notice, encoding='utf8', newline='\n')
print('Preserved archived component licenses, patent grants and all NVIDIA header notices.')
