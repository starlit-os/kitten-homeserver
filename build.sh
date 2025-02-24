#!/bin/bash

set -ouex pipefail

# Packages

dnf install -y avahi cockpit cockpit-machines cockpit-podman cockpit-files libvirt tmux vim firewalld

dnf install -y \
    usbutils

# Docker install: https://docs.docker.com/engine/install/centos/#install-using-the-repository
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
dnf install -y docker-ce docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Tailscale
dnf config-manager --add-repo https://pkgs.tailscale.com/stable/centos/9/tailscale.repo
dnf config-manager --set-disabled tailscale-stable
dnf -y --enablerepo tailscale-stable install \
  tailscale

# Fix group IDs
groupmod -g 250 docker

# Services

systemctl enable cockpit.socket
systemctl enable tailscaled.service
systemctl enable docker.service
systemctl enable docker.socket
systemctl disable rpm-ostree-countme.timer

# Don't automatically restart when autoupdating.
sed -i 's/ --apply//' /usr/lib/systemd/system/bootc-fetch-apply-updates.service

cat >/usr/lib/bootc/kargs.d/00-vfio.toml <<EOF
kargs = ["intel_iommu=on", "iommu=pt"]
match-architectures = ["x86_64"]
EOF

KERNEL_SUFFIX=""
QUALIFIED_KERNEL="$(rpm -qa | grep -P 'kernel-(|'"$KERNEL_SUFFIX"'-)(\d+\.\d+\.\d+)' | sed -E 's/kernel-(|'"$KERNEL_SUFFIX"'-)//')"
/usr/bin/dracut --no-hostonly --kver "$QUALIFIED_KERNEL" --reproducible --zstd -v -f
