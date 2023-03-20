FROM quay.io/coreos/coreos-installer:release AS installer

WORKDIR /workspace

RUN /usr/sbin/coreos-installer download -f qcow2.xz -p qemu && \
    unxz *.qcow2.xz

FROM scratch
COPY --from=installer --chown=107:107 /workspace/*.qcow2 /disk/fcos.qcow2
