variable "k8s-version" {
  type = string
}

source "qemu" "ubuntu" {
  accelerator = "hvf"
  disk_discard = "unmap"
  disk_image = true
  disk_interface = "virtio-scsi"
  disk_size = "51200M"
  headless = true
  http_directory = "./cloud-data"
  iso_checksum = "file:https://cloud-images.ubuntu.com/jammy/current/SHA256SUMS"
  iso_url = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  qemuargs = [
    [
      "-smbios",
      "type=1,serial=ds=nocloud-net;instance-id=packer;seedfrom=http://{{ .HTTPIP }}:{{ .HTTPPort }}/"
    ]
  ]
  ssh_password = "ubuntupassword"
  ssh_username = "ubuntu"
  type = "qemu"
}

build {
  sources = ["source.qemu.ubuntu"]

  provisioner "file" {
    source = "./install.sh"
    destination = "/tmp/install.sh"
  }
  provisioner "shell" {
    inline = [
      "sudo bash /tmp/install.sh ${var.k8s-version}"
    ]
  }
  provisioner "shell" {
    execute_command = "sudo sh -c '{{ .Vars }} {{ .Path }}'"
    inline = [
      "mv /etc/netplan/50-cloud-init.yaml /root/",
      "mv /etc/sudoers.d/90-cloud-init-users /root/",
      "/usr/bin/truncate --size 0 /etc/machine-id",
      "rm -r /var/lib/cloud /var/lib/dbus/machine-id ",
      "for i in group gshadow passwd shadow subuid subgid; do mv /etc/$i- /etc/$i; done",
      "/bin/sync",
      "/sbin/fstrim -v /"
    ]
    remote_folder = "/tmp"
  }
}
