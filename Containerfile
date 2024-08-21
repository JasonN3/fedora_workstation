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
RUN dnf install -y virt-manager man ceph-base ceph-fuse wine boundary gnome-network-displays gstreamer1-plugin-* gstreamer1-vaapi

# Remove unwanted packages
RUN dnf remove -y firefox

# Disable non-functional services
# RUN rm /usr/etc/systemd/system/systemd-remount-fs.service

# Enable services
#RUN mkdir -p /usr/etc/systemd/system/sockets.target.wants && ln -s /usr/lib/systemd/system/virtqemud.socket /usr/etc/systemd/system/sockets.target.wants/virtqemud.socket

RUN dnf clean all

RUN QUALIFIED_KERNEL="$(rpm -qa kernel | cut -d- -f2-)" && \
    dracut --no-hostonly --kver "$QUALIFIED_KERNEL" --reproducible -v --add ostree -f "/lib/modules/$QUALIFIED_KERNEL/initramfs.img" && \
    chmod 0600 "/lib/modules/$QUALIFIED_KERNEL/initramfs.img"

# Cleanup temp directories
RUN rm -Rf /var/roothome

RUN ostree container commit

RUN bootupctl backend generate-update-metadata
