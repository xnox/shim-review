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
Canonical Ltd.

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
- Name: Julian Andres Klode
- Position: engineer
- Email address: julian.klode@canonical.com
- PGP key: juliank.pub

-------------------------------------------------------------------------------
Who is the secondary contact for security updates, etc.
-------------------------------------------------------------------------------
- Name: dann frazier
- Position: engineer
- Email address: dannf@ubuntu.com
- PGP key: dannf.pub

-------------------------------------------------------------------------------
What upstream shim tag is this starting from:
-------------------------------------------------------------------------------
15 + commits up to a4a1fbe with added patches

-------------------------------------------------------------------------------
URL for a repo that contains the exact code which was built to get this binary:
-------------------------------------------------------------------------------
https://code.launchpad.net/~ubuntu-core-dev/shim/+git/shim/+ref/master

-------------------------------------------------------------------------------
What patches are being applied and why:
-------------------------------------------------------------------------------
  * d/p/Fix-OBJ_create-to-tolerate-a-NULL-sn-and-ln.patch: Fix NULL
    pointer dereference when calling OBJ_create() that leads to an
    exception error on arm64. (LP: #1811901)
  * debian/patches/MokManager-avoid-unaligned.patch: Fix compilation with GCC9:
    avoid -Werror=address-of-packed-member errors in MokManager.
  * debian/patches/tpm-correctness-1.patch,
    debian/patches/tpm-correctness-2.patch: fix issues in TPM calls to ensure
    the measurements are consistent with what is entered in the TPM event log.
  * debian/patches/tpm-correctness-3.patch: Don't log duplicate identical
    TPM events.
  * debian/patches/MokManager-hidpi-support.patch: Do a little bit more to
    try to get a more usable screen resolution for MokManager when running on
    HiDPI screens; by trying to detect such cases and switching to mode 0.
  * d/patches/fix-path-checks.patch: Cherry-pick upstream fix for regression
    in loading fwupd, or anything else specified as an argument (LP: #1864223)

-------------------------------------------------------------------------------
What OS and toolchain must we use to reproduce this build?  Include where to find it, etc.  We're going to try to reproduce your build as close as possible to verify that it's really a build of the source tree you tell us it is, so these need to be fairly thorough. At the very least include the specific versions of gcc, binutils, and gnu-efi which were used, and where to find those binaries.
-------------------------------------------------------------------------------
Ubuntu 20.04
binutils 2.34-4ubuntu1
gcc-9 9.3.0-3ubuntu1
gnu-efi 3.0.9-1
libc6-dev 2.31-0ubuntu6

To build:

Use included Dockerfile;

OR

Any distro with LXD that can run a daily ubuntu container will
suffice.

- lxd init   # follow the defaults

Steps to build shim:
- lxc launch ubuntu:eoan
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
buildlog_ubuntu-eoan-amd64.shim_15+1552672080.a4a1fbe-0ubuntu1_BUILDING.txt
buildlog_ubuntu-eoan-arm64.shim_15+1552672080.a4a1fbe-0ubuntu1_BUILDING.txt

-------------------------------------------------------------------------------
Put info about what bootloader you're using, including which patches it includes to enforce Secure Boot here:
-------------------------------------------------------------------------------
grub2 2.04-1ubuntu22

Patch set for EFI is from https://github.com/rhboot/grub2/commits/grub-2.02-sb
Patches are all available in the repo for grub2:
https://git.launchpad.net/~ubuntu-core-dev/grub/+git/ubuntu/tree/debian/patches?h=ubuntu
... and marked "linuxefi_*" for the SecureBoot specific patches.

Patches from Debian are not specially marked; but as the code is based on Debian's GRUB,
Ubuntu-specific patches are marked "ubuntu-*"

-------------------------------------------------------------------------------
Put info about what kernel you're using, including which patches it includes to enforce Secure Boot here:
-------------------------------------------------------------------------------
Varying Linux kernel versions; see https://launchpad.net/ubuntu/+source/linux

