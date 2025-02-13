#!/usr/bin/env bash

set -euox pipefail

dnf -y install 'dnf-command(versionlock)'
dnf versionlock add kernel kernel-devel kernel-devel-matched kernel-core kernel-modules kernel-modules-core kernel-modules-extra kernel-uki-virt
dnf -y update

dnf -y install 'dnf-command(config-manager)'
dnf config-manager --set-enabled crb
dnf -y install epel-release

# Install ublue-os stuff
dnf install -y \
    /tmp/rpms/config/ublue-os-{luks,udev-rules}.noarch.rpm

# add some packages present in Fedora CoreOS but not CentOS bootc
dnf -y install --setopt=install_weak_deps=False \
  audit \
  clevis-dracut \
  clevis-pin-tpm2 \
  firewalld \
  git-core \
  hwdata \
  iscsi-initiator-utils \
  rsync \
  ssh-key-dir \
  wireguard-tools

# Fix some missing directories and files
mkdir -p /var/lib/rpm-state
touch /var/lib/rpm-state/nfs-server.cleanup
#mkdir -p /var/lib/gssproxy/{rcache,clients}

# remove some packages present in CentOS bootc but not Fedora CoreOS
dnf -y remove \
  gssproxy \
  nfs-utils \
  quota \
  quota-nls

# enable systemd-resolved for proper name resolution
systemctl enable systemd-resolved.service

# Copy ucore workaround services and enable them
cp /tmp/ucore/systemd/system/libvirt-workaround.service /usr/lib/systemd/system/
cp /tmp/ucore/tmpfiles/libvirt-workaround.conf /usr/lib/tmpfiles.d/
systemctl enable libvirt-workaround.service
