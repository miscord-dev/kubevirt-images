FROM quay.io/coreos/coreos-installer:release AS installer

WORKDIR /workspace

RUN /usr/sbin/coreos-installer download -f iso

FROM scratch
COPY --from=installer --chown=107:107 /workspace/*.iso /disk/fcos.img
