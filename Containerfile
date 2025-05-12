FROM ghcr.io/jasonn3/fedora_base:main AS workstation

# Temporarily create directories needed for installing
RUN mkdir /var/lib/alternatives

# Install Workstation
RUN dnf install -y @workstation-product-environment --exclude firefox && \
    dnf clean all

# Split custom work to separate image layer
FROM workstation

COPY rootfs/ /

# Install additional packages
RUN dnf install -y virt-manager man ceph-base ceph-fuse wine boundary gnome-network-displays gstreamer1-plugin-* gstreamer1-vaapi && dnf clean all

# Disable non-functional services
# RUN rm /usr/etc/systemd/system/systemd-remount-fs.service

# Enable services
#RUN mkdir -p /usr/etc/systemd/system/sockets.target.wants && ln -s /usr/lib/systemd/system/virtqemud.socket /usr/etc/systemd/system/sockets.target.wants/virtqemud.socket

# Copy users and groups from packages
RUN cp /etc/passwd /usr/etc/passwd && \
    cp /etc/group /usr/etc/group
