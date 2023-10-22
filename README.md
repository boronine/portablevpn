# Portable OpenVPN

When you wish to re-host a VPN server while maintaining existing working client configs, you run into configuration
and compatibility problems.

This solution creates a "golden" Docker image tarball that can be re-hosted on any Docker-compatible platform.

The heavy lifting is done by [@ix-ai's OpenVPN configuration script](https://github.com/ix-ai/openvpn).

# Build

Generate Docker image tarball and 16 OpenVPN client configs in `dist` folder:

```bash
PORTABLEVPN_HOSTNAME=myvpnwebsite.com ./build.sh
```

## Deploy on a Linux server

From local machine:

```bash
scp dist/myvpnwebsitecom.tar myvpnwebsite.com:/home/ubuntu/
```

From server:

```bash
# optional cleanup
docker container stop myvpnwebsitecom
docker container rm myvpnwebsitecom
docker image rm myvpnwebsitecom:latest
# load and run
docker image load < myvpnwebsitecom.tar
docker run -d --name myvpnwebsitecom --cap-add=NET_ADMIN -p 443:1194/tcp myvpnwebsitecom:latest
```
