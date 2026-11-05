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
