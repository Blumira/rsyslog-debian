# rsyslog

This repository manages Blumira's custom patches for rsyslog.
* An output module that escapes line-feed characters.
* Patch to disable certificate requests.
* Build script that disables build options that we don't need.


## More details

### Output module that escapes line-feed characters.

This module removes any terminating CR or LF or CR-LF byte sequences,
and then replaces all the remaining LF and CR-LF byte sequences with #012
(the octal escape code for LF).

The escape format is similar to the built-in $EscapeControlCharactersOnReceive
option, but only applies to carriage-return and line-feed characters.


### Patch to disable certificate requests.

When using TLS, rsyslog always sends a certificate request packet back to the
client as part of the TLS handshake.  According to the RFC, the client can
respond with an empty list of client certifiates if it doesn't have one.

However, we've observed that clients that use Microsoft's TLS libraries
(in particular any client written in C#) throws an exception if it receives
a certificate request from the server but doesn't have a certificate to
send back.

Since we don't currently require clients to have client certificates, we
can be compatible with more clients if we disable the certificate request
on the server.

We have made this behavior configurable: if you do not specify any CA file
for rsyslog to use, it will not request client certificates.  This makes sense
because a CA file containing trusted CA signers is required in order to
verify client certificates.


### Build script that disables build options that we don't need.

We need very few rsyslog features, so our build script disables a vast majority
of the build options.


## Licensing

Because rsyslog is licensed under GPLv3, and because we are distributing this
patched rsyslog to customers, we must publish our changes.  We do this via a
public github repository.
