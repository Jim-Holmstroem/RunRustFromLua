FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install --assume-yes \
        build-essential \
        rustc \
        cargo \
        luajit

WORKDIR /root

# rustc + cargo is rather old in Ubuntu:16

COPY rust/Cargo.* rust/
RUN cd rust && cargo update && cd -

COPY rust rust
RUN cd rust && cargo build --release && cd -

COPY lua lua

ENTRYPOINT [ "/bin/sh",  "-c", "LD_LIBRARY_PATH=rust/target/release/ /usr/bin/env luajit lua/hello_ffi.lua" ]
