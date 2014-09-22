# - try to find libFLAC
#
# Users may optionally supply:
#  LIBFLAC_ROOT_DIR - a prefix to start searching.
#
# Cache Variables: (probably not for direct use in your scripts)
#  LIBFLAC_INCLUDE_DIR
#  LIBFLAC_LIBRARY
#
# Non-cache variables you might use in your CMakeLists.txt:
#  LIBFLAC_FOUND
#  LIBFLAC_INCLUDE_DIRS
#  LIBFLAC_LIBRARIES
#
# Requires these CMake modules:
#  FindPackageHandleStandardArgs (known included with CMake >=2.6.2)
#  FindPkgConfig (standard)
#
# Original Author:
# 2014 Ryan Pavlik <ryan.pavlik@gmail.com> <abiryan@ryand.net>
# http://ryanpavlik.com
# Iowa State University HCI Graduate Program/VRAC
#
# Copyright Iowa State University 2014.
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
# http://www.boost.org/LICENSE_1_0.txt)

set(LIBFLAC_ROOT_DIR
	"${LIBFLAC_ROOT_DIR}"
	CACHE
	PATH
	"Path to search for LIBFLAC library")

if(LIBFLAC_ROOT_DIR)
    set(_oldprefix ${CMAKE_PREFIX_PATH})
    set(CMAKE_PREFIX_PATH "${LIBFLAC_ROOT_DIR}" ${CMAKE_PREFIX_PATH})
endif()

find_package(PkgConfig QUIET)

if(PKG_CONFIG_FOUND)
    pkg_check_modules(LIBFLAC_PC flac)
endif()
find_path(LIBFLAC_INCLUDE_DIR
	NAMES
	FLAC/all.h
	HINTS
	${LIBFLAC_PC_INCLUDE_DIRS})

find_library(LIBFLAC_LIBRARY
	NAMES
	FLAC
	HINTS
	${LIBFLAC_PC_LIBRARY_DIRS})

mark_as_advanced(LIBFLAC_LIBRARY LIBFLAC_INCLUDE_DIR)

# handle the QUIETLY and REQUIRED arguments and set xxx_FOUND to TRUE if
# all listed variables are TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(LibFLAC
	DEFAULT_MSG
	LIBFLAC_LIBRARY
	LIBFLAC_INCLUDE_DIR)


if(LIBFLAC_FOUND)
	set(LIBFLAC_INCLUDE_DIRS "${LIBFLAC_INCLUDE_DIR}")
	set(LIBFLAC_LIBRARIES ${LIBFLAC_LIBRARY})
	mark_as_advanced(LIBFLAC_ROOT_DIR)
endif()

if(LIBFLAC_ROOT_DIR)
    set(CMAKE_PREFIX_PATH ${_oldprefix})
endif()

