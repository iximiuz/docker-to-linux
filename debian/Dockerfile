FROM amd64/debian:stable
LABEL com.iximiuz-project="docker-to-linux"
RUN apt-get -y update
RUN apt-get -y install --no-install-recommends \
  linux-image-amd64 \
  systemd-sysv iproute2 dnsutils vim isc-dhcp-client iputils-ping net-tools
RUN echo "root:root" | chpasswd
