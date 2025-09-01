
#!/usr/bin/env sh

# set -e

# if [[ -z "$PORTABLEVPN_HOSTNAME" ]]; then
#     echo "Must provide PORTABLEVPN_HOSTNAME in environment"
#     exit 1
# fi

# rm -rf build dist
# mkdir dist

# # Build and print logs
# docker build --progress=plain .
# # Extract SHA256 of the image
# IMAGE_ID=$(docker build -q .)
# docker save "$IMAGE_ID" > "dist/portablevpn.tar"
# docker image rm "$NAME" 2> /dev/null
# CONTAINER_ID=$(docker create $IMAGE_ID)
# docker cp "$CONTAINER_ID:/openvpn-ca/pki" build
# docker rm "$CONTAINER_ID" 2> /dev/null

for i in $(seq 1 128); do
    {
        echo "client"
        echo "nobind"
        echo "dev tun"
        echo "remote-cert-tls server"
        echo "remote $PORTABLEVPN_HOSTNAME 443 tcp"
        echo "<key>"
        sed -n '/-----BEGIN PRIVATE KEY-----/,/-----END PRIVATE KEY-----/p' "build/private/client$i.key"
        echo "</key>"
        echo "<cert>"
        sed -n '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/p' "build/issued/client$i.crt"
        echo "</cert>"
        echo "<ca>"
        sed -n '/-----BEGIN CERTIFICATE-----/,/-----END CERTIFICATE-----/p' "build/ca.crt"
        echo "</ca>"
        echo "key-direction 1"
        echo "redirect-gateway def1"

    } > "dist/atlas2-$i.ovpn"
done
