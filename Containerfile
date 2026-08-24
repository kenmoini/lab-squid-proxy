# podman build -t squid-proxy -f Containerfile .
# podman tag squid-proxy quay.io/kenmoini/squid-proxy:latest
# podman tag squid-proxy quay.io/kenmoini/squid-proxy:$(date +'%F')
# podman push quay.io/kenmoini/squid-proxy:latest
# podman push quay.io/kenmoini/squid-proxy:$(date +'%F')

#FROM registry.access.redhat.com/ubi8/ubi:8.8-1067.1698056881
FROM quay.io/centos/centos:stream9

RUN dnf update -y \
 && dnf install -y squid openssl conntrack-tools \
 && dnf clean all \
 && rm -rf /var/cache/yum

COPY container_root/ /

RUN update-ca-trust

#RUN mkdir -p /var/run/squid \
#    && chown squid:squid /var/run/squid

###### HTTPS MitM
# HTTP PROXY
EXPOSE 3128
# Intercept/DNAT
EXPOSE 3228
# TPROXY
EXPOSE 3328

###### No MitM
# HTTP PROXY
EXPOSE 3129
# Intercept/DNAT
EXPOSE 3229
# TPROXY
EXPOSE 3329

#USER squid

CMD /start.sh
