FROM quay.io/coreos/coreos-installer:release AS installer

WORKDIR /workspace

RUN /usr/sbin/coreos-installer download -f iso

FROM scratch
ADD --from=installer --chown=107:107 *.iso /disk/fcos.img
