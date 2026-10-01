"""Fail when a 64-bit native library in an APK/AAB is not 16 KB-page aligned.

Google Play rejects such builds, but only when a release is committed - the
upload to the internal track and a dry run both pass - so check right after
building instead.
usage: check_16kb_pages.py <app.aab|app.apk> [...]
"""

import re
import struct
import sys
import zipfile

LIB = re.compile(r"(^|/)lib/(arm64-v8a|x86_64)/[^/]+\.so$")
PT_LOAD = 1
PAGE = 16384


def min_load_alignment(elf):
    if elf[:4] != b"\x7fELF" or elf[4] != 2:  # ELF64 only
        return None
    phoff = struct.unpack_from("<Q", elf, 0x20)[0]
    phentsize, phnum = struct.unpack_from("<HH", elf, 0x36)
    aligns = [
        struct.unpack_from("<Q", elf, phoff + i * phentsize + 48)[0]
        for i in range(phnum)
        if struct.unpack_from("<I", elf, phoff + i * phentsize)[0] == PT_LOAD
    ]
    return min(aligns) if aligns else None


def main(paths):
    failed = False
    for path in paths:
        checked, bad = 0, []
        with zipfile.ZipFile(path) as z:
            for name in z.namelist():
                if not LIB.search(name):
                    continue
                align = min_load_alignment(z.read(name))
                if align is None:
                    continue
                checked += 1
                if align < PAGE:
                    bad.append((name, align))
        print(f"{path}: {checked} 64-bit native libraries, {len(bad)} not 16 KB aligned")
        for name, align in bad:
            print(f"::error::{name} has LOAD segments aligned to 0x{align:x}; Google Play needs 0x{PAGE:x}")
        failed |= bool(bad) or checked == 0
        if checked == 0:
            print(f"::error::no 64-bit native libraries found in {path}")
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main(sys.argv[1:])
