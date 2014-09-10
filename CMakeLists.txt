
cmake_minimum_required(VERSION 2.8.5)

# Set package properties
project(audiere)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
include(OptionRequires)
# All options:
#USE_DUMB
#USE_FLAC
#USE_LIBCDAUDIO
#USE_OGG
#USE_SPEEX

#USE_AL
#USE_ALSA
#USE_COREAUDIO
#USE_DSOUND
#USE_PA
#USE_PULSE
#USE_SDL
#USE_OSS
#USE_WINMM

set(OTHER_NIX FALSE)
if(WIN32)
	# TODO
	# search for dsound
elseif(APPLE)
	# TODO
	# search for coreaudio
else()
	set(OTHER_NIX TRUE)
    find_package(ALSA)
	# TODO
	# search for oss
	# search for pulseaudio
endif()

# TODO
# search for pa, sdl

# TODO search for: dumb, flac, ogg, speex
if(NOT WIN32)
	# TODO
	# search for libcdaudio
endif()

option_requires(USE_AL "Use the OpenAL backend" AL_FOUND) #TODO
option_requires(USE_ALSA "Use the ALSA backend" ALSA_FOUND)
option_requires(USE_COREAUDIO "Use the CoreAudio backend" COREAUDIO_FOUND) #TODO
option_requires(USE_DSOUND "Use DirectSound backend" DIRECTSOUND_FOUND) #TODO
option_requires(USE_PA "Use PortAudio backend" PA_FOUND) #TODO
option_requires(USE_PULSE "Use PulseAudio backend" PULSE_FOUND) #TODO
option_requires(USE_SDL "Use SDL backend" SDL_FOUND) #TODO
option_requires(USE_OSS "Use OSS backend" OSS_FOUND) #TODO
option_requires(USE_WINMM "Use WinMM backend" WIN32)

if(NOT WIN32)
	mark_as_advanced(USE_DSOUND USE_WINMM)
endif()
if(NOT APPLE)
	mark_as_advanced(USE_COREAUDIO)
endif()
if(NOT OTHER_NIX)
	mark_as_advanced(USE_ALSA USE_OSS USE_PULSE)
endif()
if(WIN32)
	mark_as_advanced(USE_LIBCDAUDIO)
endif()

include_directories(src)

add_subdirectory(src)
