ARG MAJOR_VERSION="${MAJOR_VERSION:-10-kitten}"

FROM ghcr.io/ublue-os/config:latest AS config
FROM quay.io/almalinuxorg/almalinux-bootc:$MAJOR_VERSION as base

# Install/remove packages to make an image with resembles Fedora CoreOS
COPY build-base.sh /tmp/build.sh
RUN --mount=type=bind,from=config,src=/rpms,dst=/tmp/rpms/config \
    /tmp/build.sh && \
    dnf clean all && \
    ostree container commit

# Build the homeserver image
FROM base

COPY build.sh /tmp/build.sh
COPY etc /etc

RUN mkdir -p /var/lib/alternatives && \
    /tmp/build.sh && \
    dnf clean all && \
    bootc container lint
