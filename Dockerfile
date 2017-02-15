FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install --assume-yes \
        build-essential \
        rustc \
        cargo \
        luajit

WORKDIR /root

# rustc + cargo is rather old in Ubuntu:16

ENTRYPOINT [ "/bin/sh", "-c" ]
