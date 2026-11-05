# SPDX-License-Identifier: MIT
# Copyright (c) 2026 Zihang Dong
import gzip
import hashlib
import json
import sys
from pathlib import Path

output = Path(sys.argv[1])
exe = (output / 'ffmpeg.exe').read_bytes()
compressed = gzip.compress(exe, compresslevel=9, mtime=0)
(output / 'ffmpeg-win32-x64.gz').write_bytes(compressed)
record = {
    'buildProfile': 'toolknit-win64-6.1.1-r2',
    'bytes': len(compressed), 'sha256': hashlib.sha256(compressed).hexdigest(),
    'exeBytes': len(exe), 'exeSha256': hashlib.sha256(exe).hexdigest(),
}
(output / 'binary-identity.json').write_text(json.dumps(record, indent=2) + '\n')
print(json.dumps(record))
