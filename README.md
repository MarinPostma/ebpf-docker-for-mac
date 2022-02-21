# Fork of eBPF for Docker Desktop on macOS, patched for use with redbpf

eBPF and its compiler bcc need access to some parts of the kernel and its headers to work. This image shows how you can do that with Docker Desktop for mac's linuxkit host VM.

On top of what is provided by the default container, this fork install redbpf and all the tools necessary to develop with in on a mac m1 inside docker.

you may need to increase the default memory in the container vm for everything to build properly.

## Build the image

Done quite simply with:

`docker build -t ebpf-for-mac .`

## Run the image

It needs to run as privileged, and depending on what you want to do, having access to the host's PID namespace is pretty useful too.

```
docker run -it --rm \
  --privileged \
  --pid=host \
  ebpf-for-mac
```

Note: /lib/modules probably doesn't exist on your mac host, so Docker will map the volume in from the linuxkit host VM.

## Maintenance

you need to change the link to the kernel sources in the header install script to match the kernel version of the docker vm on osx

## Docker compose

```yaml
#compose.yml
services:
  bpf:
    image: ebpf-for-mac
    volumes:
      - .:/wdir
    privileged: true
    pid: "host"
    command: tail -F hello
```
