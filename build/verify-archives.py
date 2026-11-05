# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Zihang Dong
import hashlib
import json
from pathlib import Path

root = Path(__file__).resolve().parent.parent
manifest = json.loads((root / 'metadata/build-sources.json').read_text())
for source in manifest['sources']:
    data = (root / source['file']).read_bytes()
    assert len(data) == source['bytes'], source['name']
    assert hashlib.sha256(data).hexdigest() == source['sha256'], source['name']
print(f"Verified all {len(manifest['sources'])} archived dependency sources.")
files = json.loads((root / 'metadata/main-source-files.json').read_text())
for entry in files:
    data = (root / manifest.get('mainSource', {}).get('directory', 'ffmpeg') / entry['path']).read_bytes()
    # Upstream explicitly declares this text fixture as eol=crlf in Git.
    if entry['path'] == 'tests/ref/fate/sub-scc':
        data = data.replace(b'\r\n', b'\n')
    assert hashlib.sha256(data).hexdigest() == entry['sha256'], entry['path']
print(f"Verified all {len(files)} FFmpeg main-source files, including outside a Git checkout.")
