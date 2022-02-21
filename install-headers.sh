#!/bin/bash

set -e
echo "downloading linux kernel sources"
cd $HOME
wget -nv -O $(uname -r).tar.gz https://mirrors.aliyun.com/linux-kernel/v5.x/linux-5.10.76.tar.gz
echo "extracting sources"
tar -zxf $(uname -r).tar.gz -C .
mv linux-5.10.76/ /usr/src/$(uname -r)


mkdir -p /lib/modules/$(uname -r)
ln -s /usr/src/$(uname -r) /lib/modules/$(uname -r)/build

echo "creating config file"
cd /usr/src/$(uname -r)
# make -r menuconfig
make -r defconfig

echo 'CONFIG_BPF=y' >> .config
echo 'CONFIG_BPF_SYSCALL=y' >> .config
echo 'CONFIG_BPF_JIT=y' >> .config
echo 'CONFIG_HAVE_EBPF_JIT=y' >> .config
echo 'CONFIG_BPF_EVENTS=y' >> .config
echo 'CONFIG_FTRACE_SYSCALLS=y' >> .config
echo 'CONFIG_KALLSYMS_ALL=y' >> .config


echo "preparing"
make -r prepare

bash

