#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

dnf5 -y install --enable-repo=terra \
	niri rofi wtype playerctl `# niri and supporting programs` \
	noctalia-shell            `# noctalia shell` \
	xdg-desktop-portal-gnome  `# screen-sharing ` \
	htop keepassxc            `# nice utilities`

# cider
rpm --import https://repo.cider.sh/RPM-GPG-KEY
tee /etc/yum.repos.d/cider.repo << 'EOF'
[cidercollective]
name=Cider Collective Repository
baseurl=https://repo.cider.sh/rpm/RPMS
enabled=1
gpgcheck=1
gpgkey=https://repo.cider.sh/RPM-GPG-KEY
EOF
dnf5 -y makecache
dnf5 -y install Cider

# vesktop
cp /ctx/99-vesktop-tmpfiles.conf /usr/lib/tmpfiles.d/
curl -L -o vesktop.rpm https://vencord.dev/download/vesktop/amd64/rpm
rpm -ivh --prefix=/usr/lib/vesktop ./vesktop.rpm

systemctl enable podman.socket

# Cleanup for lint
rm -fr /run/dnf /var/lib/dnf
