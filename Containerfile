FROM ghcr.io/jasonn3/fedora_base:main AS workstation

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

# Install additional packages
RUN dnf install -y virt-manager ceph-base ceph-fuse man

# Remove unwanted packages
RUN dnf remove -y firefox

# Create sym link for qemu socket
RUN ln -s ../../run/libvirt /var/run/libvirt

# Disable non-functional services
RUN systemctl disable systemd-remount-fs.service gssproxy.service

# Enable services
RUN systemctl enable virtqemud.socket

COPY rootfs/ /
