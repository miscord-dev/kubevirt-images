FROM quay.io/coreos/coreos-installer:release AS installer

WORKDIR /workspace

RUN /usr/sbin/coreos-installer download --decompress -f qcow2.xz -p openstack

FROM scratch

COPY --from=installer --chown=107:107 /workspace/*.qcow2 /disk/fcos.qcow2
