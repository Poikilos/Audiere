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

set(API audiere.h)

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

# Codecs
if(USE_DUMB)
	list(APPEND SOURCES input_mod.cpp input_mod.h)
endif()

if(USE_FLAC)
	list(APPEND SOURCES input_flac.cpp input_flac.h)
endif()

if(USE_OGG)
	list(APPEND SOURCES input_ogg.cpp input_ogg.h)
endif()

if(USE_SPEEX)
	list(APPEND SOURCES
		input_speex.cpp
		input_speex.h
		speexfile/speexfile.cpp
		speexfile/speexfile.h)
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


# Devices
if(USE_AL)
	add_definitions(-DHAVE_AL)
	list(APPEND SOURCES device_al.cpp device_al.h)
endif()

if(USE_ALSA)
	add_definitions(-DHAVE_ALSA)
	list(APPEND SOURCES device_alsa.cpp device_alsa.h)
endif()

if(USE_COREAUDIO)
	add_definitions(-DHAVE_CORE_AUDIO)
	list(APPEND SOURCES device_coreaudio.cpp device_coreaudio.h)
endif()

if(USE_DSOUND)
	add_definitions(-DHAVE_DSOUND)
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
	add_definitions(-DHAVE_OSS)
	list(APPEND SOURCES device_oss.cpp device_oss.h)
endif()

if(USE_PA)
	add_definitions(-DHAVE_PA)
	list(APPEND SOURCES device_pa.cpp device_pa.h)
endif()

if(USE_PULSE)
	add_definitions(-DHAVE_PULSE)
	list(APPEND SOURCES device_pulse.cpp device_pulse.h)
endif()

if(USE_SDL)
	add_definitions(-DHAVE_SDL)
	list(APPEND SOURCES device_sdl.cpp device_sdl.h)
endif()

if(USE_WINMM)
	add_definitions(-DHAVE_WINMM)
	list(APPEND SOURCES device_mm.cpp device_mm.h midi_mci.cpp)
	list(APPEND LIBS winmm)
endif()


# env.Append(CCFLAGS=['/EHsc', '/Z7', '/O2', '/W3'],
# LINKFLAGS=['/DEBUG'],
# CPPDEFINES=['AUDIERE_EXPORTS', 'NOMINMAX', 'FLAC__NO_DLL', '_CRT_SECURE_NO_WARNINGS', 'WIN32'],
# CPPPATH=['#/third-party/vc6/include'],
# LIBPATH=['#/third-party/vc6/lib'],
# LIBS=['user32', 'ole32', 'rpcrt4', 'winmm'])

add_definitions(-DAUDIERE_EXPORTS)
add_library(audiere SHARED ${SOURCES} ${API})
target_link_libraries(audiere ${LIBS})