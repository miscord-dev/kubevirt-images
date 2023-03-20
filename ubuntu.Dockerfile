FROM scratch

ADD --chown=107:107 https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img /disk/fcos.img
