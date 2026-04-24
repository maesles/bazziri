#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# Install Base packages
dnf5 -y install tmux podman

dnf5 -y copr enable gmaglione/podman-bootc
dnf5 -y install podman-bootc
dnf5 -y copr disable gmaglione/podman-bootc

#### Example for enabling a System Unit File

systemctl enable podman.socket

# Cleanup for lint
rm -fr /run/dnf
