FROM quay.io/centos-bootc/centos-bootc:stream10

COPY build.sh /tmp/build.sh

COPY etc /etc

RUN mkdir -p /var/lib/alternatives && \
    /tmp/build.sh && \
    bootc container lint
