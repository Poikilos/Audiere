set(LIBS)
set(API audiere.h)
set(SOURCES
	basic_source.cpp
	basic_source.h
	debug.cpp
	debug.h
	default_file.h
	device.cpp
	device.h
	device_mixer.cpp
	device_mixer.h
	device_null.cpp
	device_null.h
	dumb_resample.cpp
	dumb_resample.h
	file_ansi.cpp
	input.cpp
	input_aiff.cpp
	input_aiff.h
	input_mp3.cpp
	input_mp3.h
	input_wav.cpp
	input_wav.h
	internal.h
	loop_point_source.cpp
	memory_file.cpp
	memory_file.h
	mpaudec/bits.c
	mpaudec/internal.h
	mpaudec/mpaudec.c
	mpaudec/mpaudec.h
	mpaudec/mpaudectab.h
	mpaudec/mpegaudio.h
	noise.cpp
	resampler.cpp
	resampler.h
	resource.h
	sample_buffer.cpp
	sound.cpp
	sound_effect.cpp
	square_wave.cpp
	threads.h
	timer.h
	tone.cpp
	types.h
	utility.cpp
	utility.h
	version.cpp)

# Timer/threads
if(WIN32)
	list(APPEND SOURCES
		timer_win32.cpp
		threads_win32.cpp)
else()
	# TODO what about timer_ansi?
	list(APPEND SOURCES
		timer_posix.cpp
		threads_posix.cpp)
endif()

# MIDI
if(USE_WINMM)
	list(APPEND SOURCES midi_mci.cpp mci_device.h)
else()
	list(APPEND SOURCES midi_null.cpp)
endif()

# CD Audio
if(USE_LIBCDAUDIO)
	list(APPEND SOURCES cd_unix.cpp)
elseif(USE_WINMM)
	list(APPEND SOURCES cd_win32.cpp)
else()
	list(APPEND SOURCES cd_null.cpp)
endif()

###
# Codecs
###
set(INPUT_DEFINES)

# Possible other defines: NO_MP3 and NO_MPAUDEC

if(USE_CODEC_MOD)
	include_directories(${DUMB_INCLUDE_DIRS})
	list(APPEND SOURCES input_mod.cpp input_mod.h)
	list(APPEND LIBS ${DUMB_LIBRARIES})
else()
	list(APPEND INPUT_DEFINES NO_DUMB)
endif()

if(USE_CODEC_FLAC)
    include_directories(${LIBFLAC_INCLUDE_DIRS})
	list(APPEND SOURCES input_flac.cpp input_flac.h)
	list(APPEND LIBS ${LIBFLAC_LIBRARIES})
	if(USE_CODEC_FLAC_STATIC)
	    add_definitions(-DFLAC__NO_DLL)
    endif()
else()
	list(APPEND INPUT_DEFINES NO_FLAC)
endif()

if(USE_CODEC_OGG)
    include_directories(${LIBOGG_INCLUDE_DIRS} ${LIBVORBIS_INCLUDE_DIRS})
	list(APPEND SOURCES input_ogg.cpp input_ogg.h)
	list(APPEND LIBS ${LIBOGG_LIBRARIES} ${LIBVORBIS_LIBRARIES})
else()
	list(APPEND INPUT_DEFINES NO_OGG)
endif()

if(USE_SPEEX)
    include_directories(${LIBSPEEX_INCLUDE_DIRS})
	list(APPEND SOURCES
		input_speex.cpp
		input_speex.h
		speexfile/speexfile.cpp
		speexfile/speexfile.h)
	list(APPEND LIBS ${LIBSPEEX_LIBRARIES})
else()
	list(APPEND INPUT_DEFINES NO_SPEEX)
endif()

# Set preprocessor flags for input codecs
set_property(SOURCE input.cpp PROPERTY COMPILE_DEFINITIONS ${INPUT_DEFINES})

###
# Devices
###
set(DEVICE_DEFINES)

if(USE_AL)
	list(APPEND DEVICE_DEFINES HAVE_AL)
	list(APPEND SOURCES device_al.cpp device_al.h)
endif()

if(USE_ALSA)
	list(APPEND DEVICE_DEFINES HAVE_ALSA)
	include_directories(${ALSA_INCLUDE_DIRS})
	list(APPEND LIBS ${ALSA_LIBS})
	list(APPEND SOURCES device_alsa.cpp device_alsa.h)
endif()

if(USE_COREAUDIO)
	list(APPEND DEVICE_DEFINES HAVE_CORE_AUDIO)
	list(APPEND SOURCES device_coreaudio.cpp device_coreaudio.h)
endif()

if(USE_DSOUND)
	list(APPEND DEVICE_DEFINES HAVE_DSOUND)
	include_directories(${DIRECTSOUND_INCLUDE_DIRS})
	list(APPEND LIBS ${DIRECTSOUND_LIBRARIES})
	list(APPEND SOURCES
		device_ds.cpp
		device_ds.h
		device_ds_buffer.cpp
		device_ds_buffer.h
		device_ds_stream.cpp
		device_ds_stream.h
		dxguid.cpp)
endif()

if(USE_OSS)
	list(APPEND DEVICE_DEFINES HAVE_OSS)
	list(APPEND SOURCES device_oss.cpp device_oss.h)
endif()

if(USE_PA)
	list(APPEND DEVICE_DEFINES HAVE_PA)
	list(APPEND SOURCES device_pa.cpp device_pa.h)
endif()

if(USE_PULSE)
	list(APPEND DEVICE_DEFINES HAVE_PULSE)
	list(APPEND SOURCES device_pulse.cpp device_pulse.h)
	include_directories(${PULSEAUDIO_INCLUDE_DIRS})
	list(APPEND LIBS ${PULSEAUDIO_LIBRARY})
endif()

if(USE_SDL)
	list(APPEND DEVICE_DEFINES HAVE_SDL)
	list(APPEND SOURCES device_sdl.cpp device_sdl.h)
	include_directories(${SDL_INCLUDE_DIR})
	list(APPEND LIBS ${SDL_LIBRARY})
endif()

if(USE_WINMM)
	list(APPEND DEVICE_DEFINES HAVE_WINMM)
	list(APPEND SOURCES device_mm.cpp device_mm.h midi_mci.cpp)
	list(APPEND LIBS winmm)
endif()

# Set preprocessor flags for output devices
set_property(SOURCE device.cpp PROPERTY COMPILE_DEFINITIONS ${DEVICE_DEFINES})

###
# Platform-specific definitions
###
if(MSVC)
	add_definitions(-D_CRT_SECURE_NO_WARNINGS)
endif()
if(WIN32)
	add_definitions(-DWIN32_LEAN_AND_MEAN -DNOMINMAX)
endif()

add_definitions(-DAUDIERE_EXPORTS)

add_library(audiere SHARED ${SOURCES} ${API})
target_link_libraries(audiere ${LIBS})
