# Build stage for system setup
FROM archlinux:latest AS base

# Update mirrorlist and system
RUN sed -i '1s/^/##Bangladesh\nServer = http:\/\/mirror.xeonbd.com\/archlinux\/\$repo\/os\/\$arch \n\n/' /etc/pacman.d/mirrorlist && \
    pacman -Syu --noconfirm && \
    pacman -S --noconfirm base base-devel ansible vi sudo curl git cmake && \
    pacman-key --init

# User setup stage
FROM base AS user-setup

# Create user and group with specific UID/GID
RUN groupadd --gid 1000 amahmod && \
    useradd -r -g amahmod -G wheel,audio,video,storage,optical amahmod && \
    mkdir -p /home/amahmod && \
    chown -R amahmod:amahmod /home/amahmod

# Configure sudo access
RUN echo 'amahmod ALL=(root) NOPASSWD:ALL' > /etc/sudoers.d/amahmod && \
    chmod 0440 /etc/sudoers.d/amahmod

# Final stage
FROM user-setup AS final

# Install Ansible collections and configure
USER amahmod
WORKDIR /home/amahmod
RUN ansible-galaxy collection install kewlfft.aur && \
    mkdir -p /home/amahmod/.ansible/collections/ansible_collections/kewlfft/aur

# Copy Ansible playbook
COPY --chown=amahmod:amahmod . ./ansible

# Set default command
CMD ["sh", "-c", "ansible-playbook ${TAGS:-} local.yml"]
