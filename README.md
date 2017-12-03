# Audiere
Audiere is old--don't use it; but if you do and you need a Windows build, you can use SethRobinson Windows binaries.
This fork is based on vancegroup's fork of Chad Austin's Audiere (see "Reasons for Fork" below).
I only made these changes out of desparation, since I wrote a whole backend based on it before finding out it was deprecated.

## Changes
* (2017-12-03) implemented all changes from https://aur.archlinux.org/packages/audiere

## Dependencies
* alsa-oss (to emulate oss since oss is deprecated--alsa-oss creates /dev/dsp, which Audiere will need in order to create a sound device--otherwise Audiere will output an error to the console saying /dev/dsp is missing)

## Reasons for Fork
* last sourceforge release was 2006
* there were changes up to 2011 in sourceforge version--but it still requires windows.h when trying to compile on linux via `scons use_dumb=no`
* <https://aur.archlinux.org/packages/audiere> was last updated 2015 and has some patches that should be added in some central (non-OS-specific) location
* On the feature request to support alsa at <https://sourceforge.net/p/audiere/feature-requests/67/> (noting that at the time, oss was already all but deprecated), anonymous replied "Whatever, patches welcome"--that was in 2007. In svn, also code is availale (see HAS_ALSA define in code, such as device.cpp; coreaudio and pa are also conditionally included there).
* latest GitHub fork was 2014 and didn't work with wx 3 (the later SethRobinson fork doesn't count--it only made changes for MSVC 32-bit & 64-bit compilation, and didn't fork from vancegroup who had done many fixes).

## Known issues
* requires oss (or emulation of /dev/dsp via alsa-oss) which is deprecated
