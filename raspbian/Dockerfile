FROM raspbian/stretch
LABEL com.iximiuz-project="docker-to-linux"
RUN apt-get -y update
RUN apt-get -y install --no-install-recommends \
  systemd-sysv \
  linux-image-rpi2
#  linux-image-rpi2-rpfv 

RUN echo "root:root" | chpasswd

