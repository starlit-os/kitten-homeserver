# Portainer Home Server

- Based on CentOS Stream9, built with bootc
- [portainer](https://www.portainer.io/)
- [cockpit](https://cockpit-project.org/)
- [tailscale](https://tailscale.com) 

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
- Update service units (run `bootc upgrade` manually for now)

## Build ISO

Clone this repo then run this to build an iso: 

```
sudo podman run --rm -it --privileged --pull=newer --net=host --security-opt label=type:unconfined_t -v $(pwd)/image-builder-iso.config.toml:/config.toml:ro -v $(pwd)/output:/output -v /var/lib/containers/storage:/var/lib/containers/storage ghcr.io/centos-workstation/bootc-image-builder:latest --type anaconda-iso ghcr.io/castrojo/portainer-centos
```
