= Submission Details =

The submitted build at https://github.com/rhboot/shim-review/issues/92
remains unchanged.

The submission fixes regressions from the signed
https://github.com/rhboot/shim-review/issues/82 submission.

We currently are unable to use #82 because it fails to boot fwupdater,
and thus prevents application of https://fwupd.org/ updates. And we
have rolled back and didn't deploy #82.

#92 is a very small update on top of #82. #82 was previously reviewed
 by martinezjavier.

= Additional Details =

== Explanation of your certificate signing scheme, if it changed (vendor_db usage). ==

Ubuntu embeds a CA certificate in the shim, and uses intermediate
certificates for signing.  Previously, we used 'Secure boot Signing'
intermediate certificate issued in 2012, chained to the 'Master
Certificate Authority'. Signatures used to look like this:

$ sbverify --list
signature 1
image signature issuers:
 - /C=GB/ST=Isle of Man/L=Douglas/O=Canonical Ltd./CN=Canonical Ltd. Master Certificate Authority
image signature certificates:
 - subject: /C=GB/ST=Isle of Man/O=Canonical Ltd./OU=Secure Boot/CN=Canonical Ltd. Secure Boot Signing
   issuer:  /C=GB/ST=Isle of Man/L=Douglas/O=Canonical Ltd./CN=Canonical Ltd. Master Certificate Authority

This intermediate certificate was used to sign vulnerable grubs, and
has been submitted for revocation via a dbx update with Microsfot.

We had a spare unused intermediate certificate prepared ahead of time,
thus for the mitigated grub will be signed using the 2017 intemediate
certificate. It will look like so:

signature 1
image signature issuers:
 - /C=GB/ST=Isle of Man/L=Douglas/O=Canonical Ltd./CN=Canonical Ltd. Master Certificate Authority
image signature certificates:
 - subject: /C=GB/ST=Isle of Man/O=Canonical Ltd./OU=Secure Boot/CN=Canonical Ltd. Secure Boot Signing (2017)
   issuer:  /C=GB/ST=Isle of Man/L=Douglas/O=Canonical Ltd./CN=Canonical Ltd. Master Certificate Authority

== Confirmation that the needed GRUB2 and kernel fixes have been applied. ==

Kernel fixes have been applied and signed with the 2017 key and released.

GRUB2 update has fixes pulled from keybase and rebased, and is being
prepared privately. The fixed grub update will use the 2017 signing
certificate.

== Explanation of why your new signing scheme does not allow old, compromisable, previously released, GRUB2 binaries to be loaded. ==

The dbx update from Microsoft will contain revocation of the 2012
'Secure Boot Signing' certificate. Both firmware and shim, will thus
reject all Ubuntu's vulnerable grub builds signed with that
certificate. This has been tested with EDKII VM and bare-metal
firmware. The 2017 certificate is chained to the 'Canonical
Ltd. Master Certificate Authority' and thus the mitigated grub will be
trusted by shim.


== Confirmation that your old shims and hashes were sent to Microsoft per their request. ==

I confirm that we have submited revocation of the old 2012 'Secure
Boot Signing' certificate to Microsoft.
