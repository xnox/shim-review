FROM ubuntu:hirsute

RUN sed -i 's/# deb-src/deb-src/' /etc/apt/sources.list
RUN apt update -y
RUN DEBIAN_FRONTEND=noninteractive apt install -y devscripts git-buildpackage software-properties-common
RUN git clone https://github.com/CanonicalLtd/shim-review.git
RUN git clone https://git.launchpad.net/~ubuntu-core-dev/shim/+git/shim
WORKDIR /shim
RUN apt build-dep -y ./
RUN gbp buildpackage -us -uc
WORKDIR /
RUN hexdump -Cv /shim-review/shimx64.efi > orig
RUN hexdump -Cv /shim/shimx64.efi > build
RUN diff -u orig build
