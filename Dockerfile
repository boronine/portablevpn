# https://github.com/ix-ai/openvpn
FROM ixdotai/openvpn:0.2.4
ARG PORTABLEVPN_HOSTNAME
ARG NAME
RUN ovpn_genconfig -u tcp://$PORTABLEVPN_HOSTNAME:443 && \
    echo "set_var EASYRSA_BATCH 1" > /etc/openvpn/vars && \
    ovpn_initpki nopass
RUN mkdir /var/ovpn
RUN for i in $(seq 16); do easyrsa build-client-full "$NAME-$i" nopass && ovpn_getclient "$NAME-$i" > "/etc/openvpn/$NAME-$i.ovpn"; done
