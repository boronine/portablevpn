# https://infotechys.com/install-openvpn-on-ubuntu-24-04/
FROM ubuntu:24.04
# EASYRSA_BATCH: Use defaults and don't ask for input
# EASYRSA_CERT_EXPIRE: Default certificate expiry is 2 years, make it 10 years
RUN apt-get update && \
    apt-get install iptables openvpn easy-rsa -y && \
    make-cadir /openvpn-ca && \
    cd /openvpn-ca && \
    echo "set_var EASYRSA_BATCH 1\nset_var EASYRSA_CERT_EXPIRE 3650" >> vars && \
    ./easyrsa init-pki && \
    ./easyrsa build-ca nopass && \
    ./easyrsa gen-req server nopass && \
    ./easyrsa sign-req server server && \
    ./easyrsa gen-dh && \
    (for i in $(seq 1 16); do ./easyrsa gen-req "client$i" nopass && ./easyrsa sign-req client "client$i"; done) && \
    apt-get remove easy-rsa -y && \
    apt-get autoremove -y && \
    apt-get clean -y
# DEBUG: Inspect certificates: openssl x509 -text -noout -in /openvpn-ca/pki/ca.crt
RUN for i in $(seq 1 16); do ./easyrsa gen-req "client$i" nopass && ./easyrsa sign-req client "client$i"; done
COPY server.conf /etc/openvpn/server.conf
EXPOSE 443/tcp
CMD iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE && mkdir -p /dev/net && mknod /dev/net/tun c 10 200 && openvpn --config /etc/openvpn/server.conf
