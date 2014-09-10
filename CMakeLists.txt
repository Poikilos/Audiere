
cmake_minimum_required(VERSION 2.8.5)

# Set package properties
project(audiere)

if(WIN32)
	option(USE_DSOUND "Use DirectSound backend" ON)
	option(USE_WINMM "Use WinMM backend" ON)
elseif(APPLE)
	option(USE_COREAUDIO "Use the CoreAudio backend" ON)
else()
	option(USE_ALSA "Use the ALSA backend" ON)
	option(USE_PULSE "Use PulseAudio backend" ON)
	option(USE_OSS "Use OSS backend" ON)
endif()

# vorbis (HAVE_OGG/NO_OGG)
# FLAC
# libdumb - linux only
# libspeex

# defines:
# dsound: HAVE_DSOUND or NO_DSOUND
# oss: HAVE_OSS or NO_OSS

include_directories(src)

add_subdirectory(src)
