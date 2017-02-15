ENVIRONMENT = docker run -it -v `pwd`:/root/:Z rua


run: build environment
	$(ENVIRONMENT) 'LD_LIBRARY_PATH=rust/target/release/ luajit lua/hello_ffi.lua'

build: environment
	$(ENVIRONMENT) 'cd rust; cargo build --release'

environment:
	docker build -t rua .
