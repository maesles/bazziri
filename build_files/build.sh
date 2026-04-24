#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# Niri and related programs
dnf5 -y install niri

# Noctalia shell, terra repo is pre configured but not enabled with bazzite
dnf5 -y install --from-repo=terra noctalia-shell

#### Example for enabling a System Unit File

systemctl enable podman.socket

# Cleanup for lint
rm -fr /run/dnf
