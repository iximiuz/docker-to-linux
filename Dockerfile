FROM amd64/debian:stable
LABEL com.iximiuz-project="docker-to-linux"
RUN apt-get -y update
RUN apt-get -y install extlinux fdisk

