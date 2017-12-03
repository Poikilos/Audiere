# Audiere
Audiere is old--don't use it; but if you do and you need a Windows build, you can use SethRobinson Windows binaries.
This fork is based on vancegroup's fork of Chad Austin's Audiere (see "Reasons for Fork" below).
I only made these changes out of desparation, since I wrote a whole backend based on it before finding out it was deprecated.

## Changes
* (2017-12-03) ensured that all audiere-svn (last updated 2011) changes were applied to this fork:
	* src/basic_source.h: changed (regression) `<string.h>` to `<string>`
	* src/debug.cpp: removed `"stdlib.h"` (already had `<cstdlib>` like svn 2011 does)
* (2017-12-03) implemented all patches from <https://aur.archlinux.org/packages/audiere>: these patches were made against the (very old) 1.9.4 unix source release, so changes were applied to this fork by hand.

### old changes noted during diffs
(between audiere-svn (last updated 2011) and vancegroup's fork)
* The device name for DeviceFrame constructor was fudged to avoid string conversion errors (AUR patch fixes this, see above).
* HAVE_SDL and HAVE_PULSE conditions added to Makefile.am
* audiere.h, utility.cpp: checks for defined WIN32||_WIN32 replaced with _WIN32
* audiere.h: push and pop pragma warning ifdef _MSC_VER, and set `#pragma warning(disable : 4786)`
* regression from string to string.h in basic_source.h (fixed, see 2017-12-03 under "Changes" above)
* debug.cpp: changed check for defined WIN32 to _WIN32
* debug.h: added `#include <cstdlib>` and changed
  ```
  #ifdef _MSC_VER
    #define ADR_ASSERT(condition, label) if (!(condition)) { __asm int 3 }
  ```
  
  to
  ```
  #ifdef _MSC_VER
    #include <intrin.h>
    #define ADR_ASSERT(condition, label) if (!(condition)) { __debugbreak(); }
  ```
* device.cpp:
  * make windows.h only included if defined _WIN32
  * add cases for: HAVE_WINMM, HAVE_DSOUND, HAVE_PULSE, HAVE_SDL
  * remove requirement that _MSC_VER not be defined for being able to use things other than directsound & winmm (affects the return value of `ADR_EXPORT(const char*) AdrGetSupportedAudioDevices()`)
  * added TRY_RECURSE and MAKE_DEVICE logic to replace broken NEED_SEMICOLON (and TRY_GROUP and TRY_DEVICE) logic
  * added (prioritized) check for the new sound systems mentioned earlier, in DoOpenDevice
  * added static_cast for ThreadedDevice
* device_ds.cpp, device_mixer.cpp, device_null.cpp, input.aiff, input_flac.cpp, input_mp3.cpp, input_speex.cpp, input_wav.cpp, loop_point_source.cpp, memory_file.cpp, resampler.cpp, sample_buffer.cpp, utility.h: parenthesis for `(std::max)` & `(std::min)` casts
* device_null.cpp: (type-o?) put extra scope braces starting on line after `ADR_GUARD...;` and ending on line before `AI_Sleep` 
* input.cpp, input_aiff.cpp, input_mp3.cpp, input_ogg.cpp, input_wav.cpp: changed `<string.h>` to `<string>`
* input_aiff.cpp: changed `#ifndef WORDS_BIGENDIAN` to `#if !defined (WORDS_BIGENDIAN) && !defined(__BIG_ENDIAN__)`
* input_ogg.cpp, input_wav.cpp: changed `#ifdef WORDS_BIGENDIAN` to `#if defined(WORDS_BIGENDIAN) || defined(__BIG_ENDIAN__)`
* input_flac.cpp, input_flac.h: changed `FLAC__StreamDecoderReadStatus FLACInputStream::read_callback`'s param `unsigned *bytes` to `size_t *bytes`
* mci_device.h: conditions for defined _M_X64
* utility.cpp: (regression) `#include <stdio.h>` (AUR patch fixes this missing include the right way, see above).
* utility.cpp: much more specific logic for AdrAtomic* including check for __GNUC__ and adding defines for `ADR_USE_WIN32_INTERLOCKED` and `ADR_USE_GCC_ATOMIC_INTRINSICS`
* configure.in:
	* `AC_ARG_ENABLE` for macsdl and sdl
	* added `LT_INIT`
	* added `AM_CONDITIONAL(HAVE_WXWINDOWS, false)`
	* added `AM_CONDITIONAL(HAVE_SDL, test "x$HAVE_SDL" = "xtrue")`
	* added `AC_CHECK_HEADER` for pulse/simple.h which affects new HAVE_PULSE define.

  
## Dependencies
* alsa-oss (to emulate oss since oss is deprecated--alsa-oss creates /dev/dsp, which Audiere will need in order to create a sound device--otherwise Audiere will output an error to the console saying /dev/dsp is missing)

## Reasons for Fork
* last sourceforge release was 2006
* there were changes up to 2011 in sourceforge version--but it still requires windows.h when trying to compile on linux via `scons use_dumb=no`
* <https://aur.archlinux.org/packages/audiere> was last updated 2015 and has some patches that should be added in some central (non-OS-specific) location
* On the feature request to support alsa at <https://sourceforge.net/p/audiere/feature-requests/67/> (noting that at the time, oss was already all but deprecated), anonymous replied "Whatever, patches welcome"--that was in 2007. In svn, also code is availale (see HAS_ALSA define in code, such as device.cpp; coreaudio and pa are also conditionally included there).
* latest GitHub fork was 2014 and didn't work with wx 3 (the later SethRobinson fork doesn't count--it only made changes for MSVC 32-bit & 64-bit compilation, and didn't fork from vancegroup who had done many fixes).

## Known issues
* configure.in should be configure.ac nowadays, to avoid extension inconsistency and/or theoretical name collisions
* possible type-o in device_null.h (see "old changes noted during diffs" above)
* requires oss (or emulation of /dev/dsp via alsa-oss) which is deprecated
