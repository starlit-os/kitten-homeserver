# Portainer

A [portainer](https://www.portainer.io/) applicance built with CentOS Stream10 and a portainer [logically bound image](https://containers.github.io/bootc/logically-bound-images.html).

## Build ISO

Clone this repo then run this to build an iso: 

```
sudo podman run --rm -it --privileged --pull=newer --net=host --security-opt label=type:unconfined_t -v $(pwd)/image-builder-iso.config.toml:/config.toml:ro -v $(pwd)/output:/output -v /var/lib/containers/storage:/var/lib/containers/storage ghcr.io/centos-workstation/bootc-image-builder:latest --type anaconda-iso ghcr.io/castrojo/portainer-centos
```
