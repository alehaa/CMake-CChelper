# This file is part of CMake-CChelper.
#
# Copyright (C)
#   2015 Alexander Haase <alexander.haase@rwth-aachen.de>
#
# See the LICENSE file in the base directory for details.
# All rights reserved.
#

include(CheckCCompilerFlag)
include(CheckSymbolExists)
include(FindPackageHandleStandardArgs)


set(C99_FLAG_CANDIDATES
	"-std=gnu11"
	"-std=c11"
)


set(CMAKE_REQUIRED_QUIET ${C11_FIND_QUIETLY})

if (NOT CMAKE_C_COMPILER_LOADED)
	message(SEND_ERROR "C11 requires C language to be enabled")
endif ()


# Search for a working compiler flag.
if (NOT C11_FLAGS)
	foreach (FLAG ${C99_FLAG_CANDIDATES})
		if(NOT CMAKE_REQUIRED_QUIET)
			message(STATUS "Try C11 flag = [${FLAG}]")
		endif()

		unset(C11_FLAG_DETECTED CACHE)
		set(CMAKE_REQUIRED_FLAGS "${FLAG}")
		check_c_compiler_flag("${FLAG}" C11_FLAG_DETECTED)
		unset(CMAKE_REQUIRED_FLAGS)
		if (C11_FLAG_DETECTED)
			set(C11_FLAGS "${FLAG}" CACHE STRING "C compiler flags for C11")
			break()
		endif ()
	endforeach ()
endif ()


# Search for optional components.
if (C11_FLAGS)
	set(CMAKE_REQUIRED_QUIET_SAVE ${CMAKE_REQUIRED_QUIET})
	set(CMAKE_REQUIRED_QUIET true)

	foreach (component IN LISTS C11_FIND_COMPONENTS)
		string(TOUPPER ${component} comp_upper)

		if (component STREQUAL "atomics" OR component STREQUAL "complex"
		    OR component STREQUAL "threads" OR component STREQUAL "vla")
			check_symbol_exists("__STDC_NO_${comp_upper}__" ""
			                    HAVE_NO_C11_${comp_upper})

			if (NOT HAVE_NO_C11_${comp_upper})
				set(C11_${component}_FOUND true CACHE STRING
				    "Wheter C11 ${component} was found.")
				mark_as_advanced(C11_${component}_FOUND)
			endif ()

		elseif (component STREQUAL "analyzable" OR component STREQUAL "iec_559"
		        OR component STREQUAL "iec_559_complex")
			check_symbol_exists("__STDC_${comp_upper}__" ""
			                    C11_${component}_FOUND)

		else (component STREQUAL "bounds")
			check_symbol_exists("__STDC_LIB_EXT1__" "" C11_bounds_FOUND)
		endif ()
	endforeach ()

	set(CMAKE_REQUIRED_QUIET ${C11_FIND_QUIETLY})
endif ()


find_package_handle_standard_args(C11 REQUIRED_VARS C11_FLAGS HANDLE_COMPONENTS)
mark_as_advanced(C11_FLAGS)
