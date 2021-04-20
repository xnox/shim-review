This repo is for review of requests for signing shim.  To create a request for review:

- clone this repo
- edit the template below
- add the shim.efi to be signed
- add build logs
- add any additional binaries/certificates/SHA256 hashes that may be needed
- commit all of that
- tag it with a tag of the form "myorg-shim-arch-YYYYMMDD"
- push that to github
- file an issue at https://github.com/rhboot/shim-review/issues with a link to your branch
- approval is ready when you have accepted tag

Note that we really only have experience with using GRUB2 on Linux, so asking
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
Please create your shim binaries starting with the 15.4 shim release tar file:
https://github.com/rhboot/shim/releases/download/15.4/shim-15.4.tar.bz2

This matches https://github.com/rhboot/shim/releases/tag/15.4 and contains
the appropriate gnu-efi source.
-------------------------------------------------------------------------------
The shim-15.4.tar.bz2 is used as the original tarball.

-------------------------------------------------------------------------------
URL for a repo that contains the exact code which was built to get this binary:
-------------------------------------------------------------------------------
https://code.launchpad.net/~ubuntu-core-dev/shim/+git/shim/+ref/master

-------------------------------------------------------------------------------
What patches are being applied and why:
-------------------------------------------------------------------------------

  * debian/patches/359.patch: Make fallback boot noninteractive
    without any delays. Currently a 5s delay is present on every boot
    in the cloud with TPM, awaiting user to potentially interrupt and
    directly boot instance with incorrect TPM measurements. In Ubuntu,
    we can only realistically support reset after boot entries are
    created to ensure firstboot userspace has correct TPM
    measurements. Submitted as https://github.com/rhboot/shim/pull/359

-------------------------------------------------------------------------------
If bootloader, shim loading is, GRUB2: is CVE-2020-14372, CVE-2020-25632,
 CVE-2020-25647, CVE-2020-27749, CVE-2020-27779, CVE-2021-20225, CVE-2021-20233,
 CVE-2020-10713, CVE-2020-14308, CVE-2020-14309, CVE-2020-14310, CVE-2020-14311,
 CVE-2020-15705, and if you are shipping the shim_lock module CVE-2021-3418
-------------------------------------------------------------------------------
grub2 2.04-1ubuntu45

Patch set for EFI is from https://github.com/rhboot/grub2/commits/grub-2.02-sb
Patches are all available in the repo for grub2:
https://git.launchpad.net/~ubuntu-core-dev/grub/+git/ubuntu/tree/debian/patches?h=ubuntu
... and marked "linuxefi_*" for the SecureBoot specific patches.

Patches from Debian are not specially marked; but as the code is based on Debian's GRUB,
Ubuntu-specific patches are marked "ubuntu-*"

Also note the many CVE patches in the same directory.

-------------------------------------------------------------------------------
What exact implementation of Secureboot in GRUB2 ( if this is your bootloader ) you have ?
* Upstream GRUB2 shim_lock verifier or * Downstream RHEL/Fedora/Debian/Canonical like implementation ?
-------------------------------------------------------------------------------
2.04 with lockdown backports, no shim_lock, with rhboot/linuxefi/Canonical like implementation.

-------------------------------------------------------------------------------
If bootloader, shim loading is, GRUB2, and previous shims were trusting affected
by CVE-2020-14372, CVE-2020-25632, CVE-2020-25647, CVE-2020-27749,
  CVE-2020-27779, CVE-2021-20225, CVE-2021-20233, CVE-2020-10713,
  CVE-2020-14308, CVE-2020-14309, CVE-2020-14310, CVE-2020-14311, CVE-2020-15705,
  and if you were shipping the shim_lock module CVE-2021-3418
  ( July 2020 grub2 CVE list + March 2021 grub2 CVE list )
  grub2:
* were old shims hashes provided to Microsoft for verification
  and to be added to future DBX update ?

  Yes, all previous Ubuntu shims submitted for revocation via DBX to Microsoft.

* Does your new chain of trust disallow booting old, affected by CVE-2020-14372,
  CVE-2020-25632, CVE-2020-25647, CVE-2020-27749,
  CVE-2020-27779, CVE-2021-20225, CVE-2021-20233, CVE-2020-10713,
  CVE-2020-14308, CVE-2020-14309, CVE-2020-14310, CVE-2020-14311, CVE-2020-15705,
  and if you were shipping the shim_lock module CVE-2021-3418
  ( July 2020 grub2 CVE list + March 2021 grub2 CVE list )
  grub2 builds ?
-------------------------------------------------------------------------------
Ubuntu shim uses a self-managed CA certificate as the VENDOR_CERT. It remains
unchanged.

2012 signing certificate + 6 grub hashes were vulnerable to the
original boothole set of CVEs and are included in the VENDOR_DBX. This
is the same set of things that was revoked by the optional uefi.org
dbx update from summer 2020.

We cannot rotate signing certificates at the moment due to pandemic
travel restrictions, thus we are revoking by-hash all grubs signed
since boothole v1 up until the March 2021 disclosure. These are
included in the VENDOR_DBX.

-------------------------------------------------------------------------------
If your boot chain of trust includes linux kernel, is
"efi: Restrict efivar_ssdt_load when the kernel is locked down"
upstream commit 1957a85b0032a81e6482ca4aab883643b8dae06e applied ?
Is "ACPI: configfs: Disallow loading ACPI tables when locked down"
upstream commit 75b0cea7bf307f362057cc778efe89af4c615354 applied ?
-------------------------------------------------------------------------------

All Ubuntu kernels in all currently supported series have the above
applied.

All vulnerable kernels are disallowed to boot by VENDOR_DBX (2012
signing cert + many kernel image hashes).

-------------------------------------------------------------------------------
If you use vendor_db functionality of providing multiple certificates and/or
hashes please briefly describe your certificate setup. If there are allow-listed hashes
please provide exact binaries for which hashes are created via file sharing service,
available in public with anonymous access for verification
-------------------------------------------------------------------------------
VENDOR_DB is not used.

-------------------------------------------------------------------------------
If you are re-using a previously used (CA) certificate, you will need
to add the hashes of the previous GRUB2 binaries to vendor_dbx in shim
in order to prevent GRUB2 from being able to chainload those older GRUB2
binaries. If you are changing to a new (CA) certificate, this does not
apply. Please describe your strategy.
-------------------------------------------------------------------------------
We are shipping vendor_dbx that includes certificates + hashes of all
vulnerable grubs & kernels that we ever signed.

-------------------------------------------------------------------------------
What OS and toolchain must we use to reproduce this build?  Include where to find it, etc.  We're going to try to reproduce your build as close as possible to verify that it's really a build of the source tree you tell us it is, so these need to be fairly thorough. At the very least include the specific versions of gcc, binutils, and gnu-efi which were used, and where to find those binaries.
If the shim binaries can't be reproduced using the provided Dockerfile, please explain why that's the case and the differences would be.
-------------------------------------------------------------------------------
Ubuntu 21.04 (Hirsute development)
binutils 2.36.1-6ubuntu1
gcc-10 10.2.1-24ubuntu1
libc6-dev 2.33-0ubuntu4

To build:

Use included Dockerfile;

OR

Any distro with LXD that can run a daily ubuntu container will
suffice.

- lxd init   # follow the defaults

Steps to build shim:
- lxc launch ubuntu:hirsute
# Note the name of the created container, shim will be built in it.
- lxc exec <container name> bash
- sed -i 's/# deb-src/deb-src/' /etc/apt/sources.list
- apt update
- apt install git-buildpackage
- git clone https://git.launchpad.net/~ubuntu-core-dev/shim/+git/shim
- cd shim
- apt build-dep -y ./
- gbp buildpackage -us -uc

-------------------------------------------------------------------------------
Which files in this repo are the logs for your build?   This should include logs for creating the buildroots, applying patches, doing the build, creating the archives, etc.
-------------------------------------------------------------------------------
Varying Linux kernel versions; see https://launchpad.net/ubuntu/+source/linux

-------------------------------------------------------------------------------
Add any additional information you think we may need to validate this shim
-------------------------------------------------------------------------------

VENDOR_DBX files for amd64 & arm64 are included in this repo as
canonical-2021_amd64.esl and canonical-2021_arm64.esl
One can unpack them using `sig-list-to-certs` utility.
After that, one can walk launchpad queues to find all the interesting
signing & uefi tarballs to verify that everything is included as
stated.
The number of hashes is large:
amd64 - 1 cert & 378 hashes
arm64 - 1 cert & 170 hashes

For our next shim after this one, we will ensure that kernel correctly
rejects kernels for kexec based on MokListXRT including by-cert
revocation, start signing such kernels with the new signing
certificate, and replaces all the hashes in the vendor dbx with the
currently in use certs.

Other changes compared with our previous shim submissions:
 - out of MokListRT mirror size considerations, we have stopped using
   shim's ephemeral signing certificate. And instead we use our
   signing cert issued by our CA to sign fb.efi & mm.efi like most
   other distros do. This also now makes our shim builds reproducible
   like everyone else.

 - Above means that our unsigned shim/fb/mm are now produced in a
   custom upload tarball during the build, and are no longer in the
   shim.deb. As that's how one submits EFI apps for signing in
   Launchpad.

 - we have disabled ExitBootServices check, to allow chainloading a
   second shim from disk, from netbooted shim+grub. All shims these
   days require signature validation thus this is safe to do. We need
   this to support secureboot in https://maas.io which by default
   netboots & recovers bare metal machines.

 - we have disabled the unacceptable 5s boot delay in fallback when
   TPM is present, as it impacts bootspeed for the noninteractive
   cloud instances that have vTPM & SecureBoot.
