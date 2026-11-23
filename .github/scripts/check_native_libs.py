"""Fail when an APK/AAB lacks a native library for any ABI it was built for.

cargokit, which builds the Rust library of the `tor` plugin, skips itself with
one log line ("Flutter plugin not found, CargoKit plugin will not be applied.")
when it does not recognise Flutter's Gradle plugin. The build still succeeds
and the app ships without the library: Play versionCode 111 had no libtor.so.

An ABI counts as built when it holds libapp.so, Flutter's compiled Dart code.
usage: check_native_libs.py <app.aab|app.apk> <libname.so> [...]
"""

import re
import sys
import zipfile

LIB = re.compile(r"(^|/)lib/([^/]+)/([^/]+\.so)$")


def main(path, required):
    libs = {}
    with zipfile.ZipFile(path) as z:
        for name in z.namelist():
            m = LIB.search(name)
            if m:
                libs.setdefault(m.group(2), set()).add(m.group(3))

    abis = sorted(abi for abi, names in libs.items() if "libapp.so" in names)
    if not abis:
        print(f"::error::no ABI with libapp.so found in {path}")
        return 1

    missing = [(abi, lib) for abi in abis for lib in required if lib not in libs[abi]]
    print(f"{path}: ABIs {', '.join(abis)}; required {', '.join(required)}; {len(missing)} missing")
    for abi, lib in missing:
        print(f"::error::lib/{abi}/{lib} is missing from {path}")
    return 1 if missing else 0


if __name__ == "__main__":
    if len(sys.argv) < 3:
        sys.exit(__doc__)
    sys.exit(main(sys.argv[1], sys.argv[2:]))
