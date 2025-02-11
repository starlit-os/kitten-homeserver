ARG MAJOR_VERSION="${MAJOR_VERSION:-10-kitten}"

FROM ghcr.io/ublue-os/config:latest AS config
FROM ghcr.io/ublue-os/ucore:stable AS ucore
FROM quay.io/almalinuxorg/almalinux-bootc:$MAJOR_VERSION as base

# Install/remove packages to make an image with resembles Fedora CoreOS
COPY build-base.sh /tmp/build.sh
RUN --mount=type=bind,from=config,src=/rpms,dst=/tmp/rpms/config \
    --mount=type=bind,from=ucore,src=/usr/lib/systemd,dst=/tmp/ucore/systemd \
    --mount=type=bind,from=ucore,src=/usr/lib/tmpfiles.d,dst=/tmp/ucore/tmpfiles \
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
