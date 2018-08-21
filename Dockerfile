FROM ubuntu:cosmic@sha256:e27913f0141e3d2ac5c4f806606d02c9eb6520bbe75925e732fad8417d1770b0

RUN apt update -y
RUN DEBIAN_FRONTEND=noninteractive apt install -y devscripts git-buildpackage software-properties-common
RUN add-apt-repository -s ppa:canonical-foundations/shim
RUN apt build-dep -y shim
RUN git clone https://github.com/CanonicalLtd/shim-review.git
RUN git clone https://git.launchpad.net/~ubuntu-core-dev/shim/+git/shim
WORKDIR /shim
RUN gbp buildpackage -us -uc
WORKDIR /
RUN hexdump -Cv /shim-review/shimx64.efi > orig
RUN hexdump -Cv /shim/shimx64.efi > build
RUN diff -u orig build
