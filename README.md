# Portainer Home Server

An example of an appliance built with bootc. Designed for your friend who wants a home server with a webui, and tailscale in case they _need you_ to go fix something. 😄 This is based on Universal Blue's [ccos](https://github.com/ublue-os/ccos) base image, which brings in CoreOS features.

- [portainer](https://www.portainer.io/) - to manage containerized applications
- [cockpit](https://cockpit-project.org/) - to manage the system via a webuit and included web terminal
- [tailscale](https://tailscale.com) - for VPN

## Download ISO

- [Download the ISO](https://download.projectbluefin.io/server.iso)

Then follow the installation instructions, remember to set up networking in the installer before continuing with the installation!

## Usage

After first boot:

- `https://<ipaddress>:9090` - access the system maintenance webui, login with your username and password.
- `https://<ipaddress>:9443` - access the portainer webui

Tailscale is available via the `tailscale` command.

## TODO (PRs welcomed!)

- Let's Encrypt setup
- Magical DNS things to make it easy to run as a home server

## Build ISO

Clone this repo then run this to build an iso: 

```
sudo podman run --rm -it --privileged --pull=newer --net=host --security-opt label=type:unconfined_t -v $(pwd)/image-builder-iso.config.toml:/config.toml:ro -v $(pwd)/output:/output -v /var/lib/containers/storage:/var/lib/containers/storage ghcr.io/centos-workstation/bootc-image-builder:latest --type anaconda-iso ghcr.io/centos-workstation/homeserver
```
