FROM ghcr.io/jasonn3/fedora_base:main AS workstation

# Temporarily create directories needed for installing
RUN mkdir /var/roothome /var/lib/alternatives

# Install Workstation
RUN dnf group install -y 'Fedora Workstation'

# Cleanup temp directories
RUN rm -Rf /var/roothome

RUN dnf clean all

# Split custom work to separate image layer
FROM workstation

# Temporarily create directories needed for installing
RUN mkdir /var/roothome

COPY rootfs/ /

# Install VSCode
RUN dnf install -y code

# Install additional packages
RUN dnf install -y virt-manager man ceph-base ceph-fuse wine

# Remove unwanted packages
RUN dnf remove -y firefox

# Disable non-functional services
# RUN rm /usr/etc/systemd/system/systemd-remount-fs.service

# Enable services
#RUN mkdir -p /usr/etc/systemd/system/sockets.target.wants && ln -s /usr/lib/systemd/system/virtqemud.socket /usr/etc/systemd/system/sockets.target.wants/virtqemud.socket

# Cleanup temp directories
RUN rm -Rf /var/roothome

RUN dnf clean all
