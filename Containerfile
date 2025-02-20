# Build the homeserver image
FROM ghcr.io/starlit-os/kittencore:fedora-latest

COPY build.sh /tmp/build.sh
COPY etc /etc

RUN mkdir -p /var/lib/alternatives && \
    /tmp/build.sh && \
    dnf clean all && \
    bootc container lint
