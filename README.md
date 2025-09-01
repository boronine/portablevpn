# Portable OpenVPN

When you wish to re-host a VPN server while maintaining existing working client configs, you run into configuration and compatibility problems.

This solution creates a "golden" OCI image tarball that can be re-hosted on any compatible platform. Client configs will not expire for 10 years. [Google DNS (8.8.8.8)](https://developers.google.com/speed/public-dns) is hardcoded.

# Build

Generate Docker image tarball and 16 OpenVPN client configs in `dist` folder:

```bash
PORTABLEVPN_HOSTNAME=myvpnwebsite.com ./build.sh
```

## Deploy on a Linux server

From local machine:

```bash
scp dist/portablevpn.tar myvpnwebsite.com:/home/ubuntu/
```

From server:

```bash
# optional cleanup
docker container stop portablevpn
docker container rm portablevpn
docker image rm portablevpn:latest
# load and run
docker image load < portablevpn.tar
docker run -d --name portablevpn --cap-add=NET_ADMIN -p 443:443/tcp portablevpn:latest
```
