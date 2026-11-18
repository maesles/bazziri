#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# enable various repos
rpm --import https://repo.cider.sh/RPM-GPG-KEY              # install cider repo key
tee /etc/yum.repos.d/terra.repo <<'EOF'
[terra]
name=Terra $releasever
#baseurl=https://repos.fyralabs.com/terra$releasever
metalink=https://tetsudou.fyralabs.com/metalink?repo=terra$releasever&arch=$basearch
metadata_expire=6h
type=rpm
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-terra$releasever
# Terra currently uses a CDN based on the origin repo, so this is safe
repo_gpgcheck=0
enabled=1
enabled_metadata=1
countme=1
EOF
tee /etc/yum.repos.d/cider.repo <<'EOF'                     # install cider
[cidercollective]
name=Cider Collective Repository
baseurl=https://repo.cider.sh/rpm/RPMS
enabled=1
gpgcheck=1
gpgkey=https://repo.cider.sh/RPM-GPG-KEY
EOF
dnf5 -y makecache

# install packages
dnf5 -y install \
	niri rofi wtype playerctl `# niri and supporting programs` \
	noctalia-legacy `# noctalia shell, legacy quickshell based` \
	noctalia-nightly `# noctalia shell, c++ rewrite` \
	xdg-desktop-portal-gnome `# screen-sharing ` \
	htop keepassxc `# nice utilities` \
	Cider `# music/cider` \
	@virtualization

# vesktop (special handling needed since it installs in /opt normally)
curl -L -o vesktop.rpm https://vencord.dev/download/vesktop/amd64/rpm
rpm -ivh --prefix=/usr/lib/vesktop ./vesktop.rpm      # install in special prefix
cp /ctx/99-vesktop-tmpfiles.conf /usr/lib/tmpfiles.d/ # use tmpfiles to create symlinks to proper files in special prefix

## fixup vesktop since the scripts hardcodes paths to /opt
chmod 0755 /usr/lib/vesktop/opt/Vesktop/chrome-sandbox

systemctl enable podman.socket

# Cleanup for lint
rm -fr /run/dnf /var/lib/dnf
