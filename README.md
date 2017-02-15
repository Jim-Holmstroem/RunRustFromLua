# RunRustFromLua

## Build
```bash
cd rust
cargo build --release
cd -
```

## Run
```bash
LD_LIBRARY_PATH=rust/target/release/ luajit lua/hello_ffi.lua
```
