FROM ubuntu:latest

## install deps
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y build-essential pkg-config libelf-dev curl lsb-release wget software-properties-common git flex bc bison libssl-dev

#install llvm
RUN wget https://apt.llvm.org/llvm.sh && chmod +x llvm.sh && ./llvm.sh 13 && rm -f ./llvm.sh

## install rust and bpf
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

RUN git clone https://github.com/foniod/redbpf.git
WORKDIR redbpf
RUN git submodule sync
RUN git submodule update --init
WORKDIR cargo-bpf
RUN $HOME/.cargo/bin/cargo install --path .

COPY install-headers.sh /root

RUN sh /root/install-headers.sh

WORKDIR /root
CMD mount -t debugfs debugfs /sys/kernel/debug && /bin/bash
