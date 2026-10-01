# libisar.so (16 KB page aligned)

`src/main/jniLibs/{arm64-v8a,x86_64}/libisar.so` replace the Android binaries
that `isar_flutter_libs` 3.1.0+1 ships. Those are linked for 4 KB pages, and
Google Play rejects 64-bit native libraries that are not 16 KB-page aligned.
`build.gradle` (`packaging.jniLibs.pickFirsts`) makes the build use these.

They are built from the same isar core the Dart package expects, so the
database format and the FFI interface are unchanged:

- Source: https://github.com/isar/isar tag `3.1.0+1` (commit `6643d064abf22606b6c6a741ea873e4781115ef4`),
  crate `packages/isar_core_ffi`.
- `ISAR_VERSION=3.1.0+1` (the Dart side refuses any other core version).
- Android NDK 28.2.13676358, platform 21, `cargo-ndk 4.1.2`, `rustc 1.97.0`,
  `RUSTFLAGS="-C link-arg=-Wl,-z,max-page-size=16384"`.
- Exported `isar_*` / JNI symbols are identical to the original binaries
  (92 per ABI); LOAD segments are 0x4000-aligned.

Rebuild:

    git clone --depth 1 --branch 3.1.0+1 https://github.com/isar/isar.git
    cd isar/packages/isar_core_ffi
    ANDROID_NDK_HOME=<sdk>/ndk/28.2.13676358 ISAR_VERSION=3.1.0+1 \
      RUSTFLAGS="-C link-arg=-Wl,-z,max-page-size=16384" \
      cargo ndk -t arm64-v8a -t x86_64 -P 21 build --release

SHA-256:

    f3cba34e7ccf3e847172121b676cb961a7eba05d395363785a363bbab7625f93  arm64-v8a/libisar.so
    5c8dd09acfea72bfe5b59609cf3cf54b9a7b6ccf16ab96092f2aeebd19c089fe  x86_64/libisar.so

The 32-bit ABIs keep the plugin's binaries (the 16 KB rule covers 64-bit only).
Drop this override once the project moves to an Isar release that ships
16 KB-aligned Android binaries.
