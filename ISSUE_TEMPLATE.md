Make sure you have provided the following information:

 - [ ] link to your code branch cloned from rhboot/shim-review in the form user/repo@tag
 - [ ] completed README.md file with the necessary information
 - [ ] shim.efi to be signed
 - [ ] public portion of your certificate(s) embedded in shim (the file passed to VENDOR_CERT_FILE)
 - [ ] binaries, for which hashes are added do vendor_db ( if you use vendor_db and have hashes allow-listed )
 - [ ] any extra patches to shim via your own git tree or as files
 - [ ] any extra patches to grub via your own git tree or as files
 - [ ] build logs
 - [ ] a Dockerfile to reproduce the build of the provided shim EFI binaries


###### What organization or people are asking to have this signed:
Canonical Ltd

###### What product or service is this for:
Ubuntu

###### Please create your shim binaries starting with the 15.4 shim release tar file:
###### https://github.com/rhboot/shim/releases/download/15.4/shim-15.4.tar.bz2
###### This matches https://github.com/rhboot/shim/releases/tag/15.4 and contains
###### the appropriate gnu-efi source.
###### Please confirm this as the origin your shim.
Build is based on shim-15.4.tar.gz2
It is located at CanonicalLtd/shim-review@ubuntu-shim-amd64+arm64-20210407

###### What's the justification that this really does need to be signed for the whole world to be able to boot it:
Ubuntu is a popular OS.

###### How do you manage and protect the keys used in your SHIM?
The CA certificate used as VENDOR_CERT is always stored offline, split
using Shamir's Secret Sharing into 7 fragments distributed globally, 3
of which are required to assemble the cert.

Thus we require international travel to be available to assemble it
and issue new certificates.

###### Do you use EV certificates as embedded certificates in the SHIM?
No.

###### If you use new vendor_db functionality, are any hashes allow-listed, and if yes: for what binaries ?
We do not use vendor_db.

###### Is kernel upstream commit 75b0cea7bf307f362057cc778efe89af4c615354 present in your kernel, if you boot chain includes a Linux kernel ?
Yes all currently supported kernels have it.
Kernels that do not have it are revoked by vendor_dbx.

###### if SHIM is loading GRUB2 bootloader, are CVEs CVE-2020-14372,
###### CVE-2020-25632, CVE-2020-25647, CVE-2020-27749, CVE-2020-27779,
###### CVE-2021-20225, CVE-2021-20233, CVE-2020-10713, CVE-2020-14308,
###### CVE-2020-14309, CVE-2020-14310, CVE-2020-14311, CVE-2020-15705,
###### ( July 2020 grub2 CVE list + March 2021 grub2 CVE list )
###### and if you are shipping the shim_lock module CVE-2021-3418
###### fixed ?
All of the above CVEs are fixed. Grubs that do not have it fixed are revoked by vendor_dbx.

###### "Please specifically confirm that you add a vendor specific SBAT entry for SBAT header in each binary that supports SBAT metadata
###### ( grub2, fwupd, fwupdate, shim + all child shim binaries )" to shim review doc ?
###### Please provide exact SBAT entries for all SBAT binaries you are booting or planning to boot directly through shim
`[your text here]`

shim, fb, mm:
sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
shim,1,UEFI shim,shim,1,https://github.com/rhboot/shim
shim.ubuntu,1,Ubuntu,shim,15.4-0ubuntu1,https://www.ubuntu.com/

grub:
sbat,1,SBAT Version,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
grub,1,Free Software Foundation,grub,2.04,https://www.gnu.org/software/grub/
grub.ubuntu,1,Ubuntu,grub2,2.04-1ubuntu45,https://www.ubuntu.com/

fwupd:
sbat,1,UEFI shim,sbat,1,https://github.com/rhboot/shim/blob/main/SBAT.md
fwupd,1,Firmware update daemon,fwupd,1.5.8,https://github.com/fwupd/fwupd
fwupd.ubuntu,1,Ubuntu,fwupd,1.5.8-0ubuntu1,https://launchpad.net/ubuntu/+source/fwupd

kernel.efi:
TBD We might start loading kernel.efi in the future which is systemd
sd-boot stub, linux kernel, initrd, cmdline as a single EFI app.

##### Were your old SHIM hashes provided to Microsoft ?
Yes, all our previously signed shims have been submitted to Microsoft.

##### Did you change your certificate strategy, so that affected by CVE-2020-14372, CVE-2020-25632, CVE-2020-25647, CVE-2020-27749,
##### CVE-2020-27779, CVE-2021-20225, CVE-2021-20233, CVE-2020-10713,
##### CVE-2020-14308, CVE-2020-14309, CVE-2020-14310, CVE-2020-14311, CVE-2020-15705 ( July 2020 grub2 CVE list + March 2021 grub2 CVE list )
##### grub2 bootloaders can not be verified ?
All vulnerable grubs are revoked by vendor_dbx.

##### What exact implementation of Secureboot in grub2 ( if this is your bootloader ) you have ?
##### * Upstream grub2 shim_lock verifier or * Downstream RHEL/Fedora/Debian/Canonical like implementation ?
grub2 2.04 + lockdown backport + rhboot/canonical like secureboot patches.

###### What is the origin and full version number of your bootloader (GRUB or other)?

Building / Publishing
https://launchpad.net/ubuntu/+source/grub2-unsigned - same signed grub binaries for all series

Git managed source code
https://code.launchpad.net/~ubuntu-core-dev/grub/+git/ubuntu/+ref/ubuntu

Note patches debian/patches

###### If your SHIM launches any other components, please provide further details on what is launched

kernel.efi:
TBD We might start loading kernel.efi in the future which is systemd
sd-boot stub, linux kernel, initrd, cmdline as a single EFI app.

###### If your GRUB2 launches any other binaries that are not Linux kernel in SecureBoot mode,
###### please provide further details on what is launched and how it enforces Secureboot lockdown
GRUB2 may launch Windows Bootmgr on dual boot systems.
Nebooted shim+grub2 may chainloader load shim+grub2 again from disk,
which will verify things again as usual. (https://maas.io usecase).

###### If you are re-using a previously used (CA) certificate, you
###### will need to add the hashes of the previous GRUB2 binaries
###### exposed to the CVEs to vendor_dbx in shim in order to prevent
###### GRUB2 from being able to chainload those older GRUB2 binaries. If
###### you are changing to a new (CA) certificate, this does not
###### apply. Please describe your strategy.
Adding all vulnerable grubs to vendor_dbx.
Also adding kernels that are vulnerable to ACPI bypass to vendor_dbx too.

###### How do the launched components prevent execution of unauthenticated code?
fwupd verifies capsule signatures; kernel implements lockdown.

Note that currently kernel does not yet implement correct checking of
MokListXRT for kexec, thus one currently can kexec revoked/old kernels
from the booted good kernel.

###### Does your SHIM load any loaders that support loading unsigned kernels (e.g. GRUB)?
No, our grub enforces lockdown & uses shim protocol (rhboot linuxefi
sb patches) to verify next component.

###### What kernel are you using? Which patches does it includes to enforce Secure Boot?
linux, various versions. They include lockdown patches & ACPI patches,
lockdown is enforced when booted with SecureBoot, config enforces
kernel module signatures under lockdown.

###### What changes were made since your SHIM was last signed?
All patches dropped, as they were merged upstream

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


###### What is the SHA256 hash of your final SHIM binary?

Plain sha256sum, unsigned EFI app:
```
$ sha256sum 15.4-0ubuntu1/shim*.efi
9a73497f75b2a4c55cfd0648f3dbcbb5a16146a8920faa9bb7e4dea495c30d65  15.4-0ubuntu1/shimaa64.efi
14bb194ea823cad03da3d79cff93ce96d3aaa910955f19f1816b937e3c7db6eb  15.4-0ubuntu1/shimx64.efi
```

Authenticode hashes:
```
$ hash-to-efi-sig-list shim*.signed /dev/null
HASH IS d00757a5bd6771b09f6243746f77b4e78e2ec8e5292a8fbe599b758356eaab22
HASH IS 6265b732b005b3f330bcd1843374e5ec6ec5aef27cdb97a23daeb8580abbf526
```
