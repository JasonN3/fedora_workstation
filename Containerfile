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

# Install VSCode
RUN curl -Lo vscode.rpm "https://code.visualstudio.com/sha/download?build=stable&os=linux-rpm-x64"; \
  dnf install -y vscode.rpm; \
  rm -f vscode.rpm; \
  dnf install -y code

# Install additional packages
RUN dnf install -y virt-manager ceph-base ceph-fuse man

# Remove unwanted packages
RUN dnf remove -y firefox

# Disable non-functional services
RUN systemctl disable systemd-remount-fs.service

# Enable services
RUN systemctl enable virtqemud.socket

COPY rootfs/ /
