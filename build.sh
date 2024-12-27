#!/bin/bash

set -ouex pipefail

# See https://github.com/centos-workstation/achillobator/issues/3
mkdir -m 0700 -p /var/roothome
# Fast track https://gitlab.com/fedora/bootc/base-images/-/merge_requests/71
ln -sf /run /var/run


systemctl enable podman.socket
