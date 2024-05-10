FROM ghcr.io/jasonn3/fedora_base:main 

# Temporarily create directories needed for installing
RUN mkdir /var/roothome

# Install Workstation
RUN dnf group install -y 'Fedora Workstation'

# Remove unwanted packages
RUN dnf remove -y firefox

# Cleanup temp directories
RUN rm -Rf /var/roothome

# Cleanup cache
RUN dnf clean all