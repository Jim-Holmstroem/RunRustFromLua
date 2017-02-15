FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install --assume-yes \
        build-essential \
        rustc \
        cargo \
        luajit

# rustc + cargo is rather old

USER user
WORKDIR /home/user

ENTRYPOINT [ "/usr/bin/make", "-f", "/home/user/Makefile" ]
