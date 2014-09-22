
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
	find_package(PulseAudio QUIET) # Installs a cmake module.
endif()

# TODO
# AL is for SGI
# search for pa, sdl
set(SDL_BUILDING_LIBRARY ON)
find_package(SDL)

# TODO search for: dumb, flac, ogg, speex
if(NOT WIN32)
	# TODO
	# search for libcdaudio
endif()

set(FLAC_STATIC_OFF_BY_DEFAULT_FLAG OFF_BY_DEFAULT)

if(WIN32)
    option(USE_BUNDLED_DUMB "Use bundled pre-compiled DUMB (CVS from 2003.06.12)" ON)
    option(USE_BUNDLED_LIBFLAC "Use bundled pre-compiled libFLAC 1.1.0 and libFLAC++ 1.1.0" ON)
    option(USE_BUNDLED_LIBSPEEX "Use bundled pre-compiled libspeex" ON)
    option(USE_BUNDLED_LIBOGG "Use bundled pre-compiled libogg 1.0" ON)
    option(USE_BUNDLED_LIBVORBIS "Use bundled pre-compiled libvorbis 1.0" ON)
    option(USE_BUNDLED_DX9SDK "Use bundled DirectX 9 SDK for DirectSound" ON)

    set(bundle_base "${CMAKE_CURRENT_SOURCE_DIR}/third-party/vc6")
    set(bundle_include "${bundle_base}/include")
    set(bundle_libs "${bundle_base}/lib")
    if(USE_BUNDLED_DUMB)
        set(DUMB_INCLUDE_DIRS "${bundle_include}")
        set(DUMB_LIBRARIES optimized "${bundle_libs}/dumb_static.lib" debug "${bundle_libs}/dumbd_static.lib")
        set(DUMB_FOUND true)
    endif()
    if(USE_BUNDLED_LIBFLAC)
        set(LIBFLAC_INCLUDE_DIRS "${bundle_include}")
        set(LIBFLAC_LIBRARIES optimized "${bundle_libs}/libFLAC_static.lib" debug "${bundle_libs}/libFLAC_static_d.lib")
        set(FLAC_STATIC_OFF_BY_DEFAULT_FLAG) # Bundled is static!
        set(LIBFLAC_FOUND true)
    endif()
    if(USE_BUNDLED_LIBSPEEX)
        set(LIBSPEEX_INCLUDE_DIRS "${bundle_include}")
        set(LIBSPEEX_LIBRARIES optimized "${bundle_libs}/libspeex.lib" debug "${bundle_libs}/libspeexd.lib")
        set(LIBSPEEX_FOUND true)
    endif()
    if(USE_BUNDLED_LIBOGG)
        set(LIBOGG_INCLUDE_DIRS "${bundle_include}")
        set(LIBOGG_LIBRARIES optimized "${bundle_libs}/ogg_static.lib" debug "${bundle_libs}/ogg_static_d.lib")
        set(LIBOGG_FOUND true)
    endif()
    if(USE_BUNDLED_LIBVORBIS)
        set(LIBVORBIS_INCLUDE_DIRS "${bundle_include}")
        set(LIBVORBIS_LIBRARIES optimized "${bundle_libs}/vorbis_static.lib" debug "${bundle_libs}/vorbis_static_d.lib"
            optimized "${bundle_libs}/vorbisfile_static.lib" debug "${bundle_libs}/vorbisfile_static_d.lib")
        set(LIBVORBIS_FOUND true)
    endif()
    if(USE_BUNDLED_DX9SDK)
        set(DIRECTSOUND_INCLUDE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}/third-party/DX9SDK/Include")
        set(DIRECTSOUND_LIBRARIES "${CMAKE_CURRENT_SOURCE_DIR}/third-party/DX9SDK/Lib/dsound.lib" rpcrt4)
        set(DIRECTSOUND_FOUND true)
    endif()

endif()

option_requires(USE_AL "Use the SGI AL backend" AL_FOUND) #TODO
option_requires(USE_ALSA "Use the ALSA backend" ALSA_FOUND)
option_requires(USE_COREAUDIO "Use the CoreAudio backend" COREAUDIO_FOUND) #TODO
option_requires(USE_DSOUND "Use DirectSound backend" DIRECTSOUND_FOUND) #TODO
option_requires(USE_PA "Use PortAudio backend" PA_FOUND) #TODO
option_requires(USE_PULSE "Use PulseAudio backend" PULSEAUDIO_FOUND)
option_requires(USE_SDL "Use SDL backend" SDL_FOUND)
option_requires(USE_OSS "Use OSS backend" OSS_FOUND) #TODO
option_requires(USE_WINMM "Use WinMM backend" WIN32)

option_requires(USE_CODEC_MOD "Use the MOD codec (DUMB library)" DUMB_FOUND) #TODO
option_requires(USE_CODEC_FLAC "Use the FLAC codec" LIBFLAC_FOUND)
option_requires(USE_CODEC_SPEEX "Use the Speex codec" LIBSPEEX_FOUND)
option_requires(USE_CODEC_OGG "Use the Ogg Vorbis codec" LIBOGG_FOUND LIBVORBIS_FOUND)

option_requires(USE_CODEC_FLAC_STATIC "Use the FLAC codec, as a static library" USE_CODEC_FLAC ${FLAC_STATIC_OFF_BY_DEFAULT_FLAG})

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
