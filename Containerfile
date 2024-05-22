FROM ghcr.io/jasonn3/fedora_base:configure AS workstation

# Temporarily create directories needed for installing
RUN mkdir /var/roothome /var/lib/alternatives

# Install Workstation
RUN dnf group install -y 'Fedora Workstation'

# Cleanup temp directories
RUN rm -Rf /var/roothome

# Cleanup cache
RUN dnf clean all

# Split custom work to separate image layer
FROM workstation

COPY rootfs/ /

# Install VSCode
RUN dnf install -y code

# Install additional packages
RUN dnf install -y virt-manager ceph-base ceph-fuse man NetworkManager-l2tp-gnome wine

# Remove unwanted packages
RUN dnf remove -y firefox

# Disable non-functional services
RUN systemctl disable systemd-remount-fs.service

# Enable services
RUN systemctl enable virtqemud.socket


