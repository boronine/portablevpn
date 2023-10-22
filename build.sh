
#!/usr/bin/env sh

if [[ -z "$PORTABLEVPN_HOSTNAME" ]]; then
    echo "Must provide PORTABLEVPN_HOSTNAME in environment"
    exit 1
fi

NAME=$(echo $PORTABLEVPN_HOSTNAME | tr -d ".")

rm -rf build dist
mkdir build dist
docker image rm "$NAME" 2> /dev/null
docker container rm "$NAME" 2> /dev/null
docker build --build-arg="PORTABLEVPN_HOSTNAME=$PORTABLEVPN_HOSTNAME" --build-arg="NAME=$NAME" --tag "$NAME" .
docker save "$NAME" > "dist/$NAME.tar"
docker container create --name "$NAME" "$NAME"
docker export "$NAME" > build/rootfs.tar
tar -xf build/rootfs.tar -C build
cp build/etc/openvpn/*.ovpn dist
