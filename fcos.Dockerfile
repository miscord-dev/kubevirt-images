# FROM quay.io/coreos/coreos-installer:release AS installer

# WORKDIR /workspace

# RUN /usr/sbin/coreos-installer download -f qcow2.xz -p qemu

FROM ubuntu:22.04 AS uncompressor

WORKDIR /workspace

RUN apt-get update && \
    apt-get install -y xz-utils && \
    apt-get install -y --no-isntall-recommends curl && \
    curl -LO https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/37.20230218.3.0/x86_64/fedora-coreos-37.20230218.3.0-qemu.x86_64.qcow2.xz
# COPY --from=installer /workspace/*.qcow2.xz /workspace

RUN apt-get update && \
    apt-get install -y xz-utils && \
    unxz *.qcow2.xz

FROM scratch
COPY --from=uncompressor --chown=107:107 /workspace/*.qcow2 /disk/fcos.qcow2
