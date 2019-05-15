This repo is for review of requests for signing shim.  To create a request for review:

- clone this repo
- edit the template below
- add the shim.efi to be signed
- add build logs
- commit all of that
- tag it with a tag of the form "myorg-shim-arch-YYYYMMDD"
- push that to github
- file an issue at https://github.com/rhboot/shim-review/issues with a link to your tag

Note that we really only have experience with using grub2 on Linux, so asking
us to endorse anything else for signing is going to require some convincing on
your part.

Here's the template:

-------------------------------------------------------------------------------
What organization or people are asking to have this signed:
-------------------------------------------------------------------------------
Ubuntu

-------------------------------------------------------------------------------
What product or service is this for:
-------------------------------------------------------------------------------
Ubuntu

-------------------------------------------------------------------------------
What's the justification that this really does need to be signed for the whole world to be able to boot it:
-------------------------------------------------------------------------------
We're a well-known Linux distro

-------------------------------------------------------------------------------
Who is the primary contact for security updates, etc.
-------------------------------------------------------------------------------
- Name: Mathieu Trudel-Lapierre
- Position: engineer
- Email address: mathieu.trudel-lapierre@canonical.com
- PGP key: cyphermox.pub

-------------------------------------------------------------------------------
Who is the secondary contact for security updates, etc.
-------------------------------------------------------------------------------
- Name:
- Position:
- Email address:
- PGP key: 

-------------------------------------------------------------------------------
What upstream shim tag is this starting from:
-------------------------------------------------------------------------------
15 + commits up to 3beb971

-------------------------------------------------------------------------------
URL for a repo that contains the exact code which was built to get this binary:
-------------------------------------------------------------------------------
https://code.launchpad.net/~ubuntu-core-dev/shim/+git/shim/+ref/master

-------------------------------------------------------------------------------
What patches are being applied and why:
-------------------------------------------------------------------------------
No patches

-------------------------------------------------------------------------------
What OS and toolchain must we use to reproduce this build?  Include where to find it, etc.  We're going to try to reproduce your build as close as possible to verify that it's really a build of the source tree you tell us it is, so these need to be fairly thorough. At the very least include the specific versions of gcc, binutils, and gnu-efi which were used, and where to find those binaries.
-------------------------------------------------------------------------------
Ubuntu 18.10
binutils 2.31.1-3ubuntu2
gcc 4:8.2.0-1ubuntu1
gnu-efi 3.0.8-0ubuntu1
libc6-dev 2.27-3ubuntu1

To build:

Any distro with LXD that can run a daily ubuntu container will
suffice.

- lxd init   # follow the defaults

Steps to build shim:
- lxc launch ubuntu-daily:cosmic
# Note the name of the created container, shim will be built in it.
- lxc exec <container name> bash
- sed -i 's/# deb-src/deb-src/' /etc/apt/sources.list
- apt update
- apt build-dep shim
- apt install git-buildpackage debhelper gnu-efi sbsigntool libelf-dev
devscripts
- git clone https://git.launchpad.net/~ubuntu-core-dev/shim/+git/shim
- cd shim
- gbp buildpackage -us -uc

-------------------------------------------------------------------------------
Which files in this repo are the logs for your build?   This should include logs for creating the buildroots, applying patches, doing the build, creating the archives, etc.
-------------------------------------------------------------------------------
buildlog_ubuntu-cosmic-amd64.shim_15+1533136590.3beb971-0ubuntu1_BUILDING.txt
buildlog_ubuntu-cosmic-arm64.shim_15+1533136590.3beb971-0ubuntu1_BUILDING.txt

-------------------------------------------------------------------------------
Put info about what bootloader you're using, including which patches it includes to enforce Secure Boot here:
-------------------------------------------------------------------------------
grub2 2.02-2ubuntu13

Patch set for EFI is from https://github.com/rhboot/grub2/commits/grub-2.02-sb
Patches are all available in the repo for grub2:
https://git.launchpad.net/~ubuntu-core-dev/grub/+git/ubuntu/tree/debian/patches?h=ubuntu
... and marked "linuxefi_*"

-------------------------------------------------------------------------------
Put info about what kernel you're using, including which patches it includes to enforce Secure Boot here:
-------------------------------------------------------------------------------
Varying Linux kernel versions; see https://launchpad.net/ubuntu/+source/linux

