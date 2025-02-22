FROM docker.io/debian:bookworm AS vng-build

# Build virtme-ng.
RUN apt update
RUN apt install -y python3-pip pipx curl
RUN curl https://sh.rustup.rs -sSf |  sh -s -- --default-toolchain stable -y
ENV PATH=/root/.cargo/bin:$PATH
COPY ./virtme-ng /virtme-ng
RUN BUILD_VIRTME_NG_INIT=1 pipx install /virtme-ng

# Flip to a new container without all the virtme-ng build dependencies.
FROM docker.io/debian:bookworm
# Install kernel depdenencies.
RUN apt update
RUN apt install -y build-essential libnuma-dev libcap-dev \
        ncurses-dev xz-utils libssl-dev bc flex libelf-dev bison qemu-system-x86
# Oh, we will need pipx to run virtme-ng. So the multiple-FROM-statement
# backflip was a bit pointless. Never mind.
RUN apt install -y pipx
# Other stuff needed by virtme-ng
RUN apt install -y file kmod libvirt-clients udev
# Install virtme-ng
COPY --from=vng-build /root/.local/ /root/.local/
ENV PATH=/root/.local/bin:$PATH