FROM docker/for-desktop-kernel:5.10.25-6594e668feec68f102a58011bb42bd5dc07a7a9b AS ksrc

FROM ubuntu:latest

## install deps
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y build-essential pkg-config libelf-dev curl lsb-release wget software-properties-common git

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

WORKDIR /
COPY --from=ksrc /kernel-dev.tar /
RUN tar xf kernel-dev.tar && rm kernel-dev.tar

RUN apt-get update
RUN apt install -y kmod python3-bpfcc

COPY hello_world.py /root

WORKDIR /root
CMD mount -t debugfs debugfs /sys/kernel/debug && /bin/bash
