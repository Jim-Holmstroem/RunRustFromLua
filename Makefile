run: build
	LD_LIBRARY_PATH=rust/target/release/ luajit lua/hello_ffi.lua

build:
	cd rust; cargo build --release

