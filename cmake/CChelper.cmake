# This file is part of CMake-CChelper.
#
# Copyright (C)
#   2015 Alexander Haase <alexander.haase@rwth-aachen.de>
#
# See the LICENSE file in the base directory for details.
# All rights reserved.
#


# Enable compiler warnings. A default option can be set via the
# CCHELPER_ENABLE_WARNINGS variable. Set it before including this file.
if (NOT DEFINED CCHELPER_ENABLE_WARNINGS)
	set(CCHELPER_ENABLE_WARNINGS true)
endif ()

option(ENABLE_WARNINGS
	"Selects whether compiler warnings are enabled."
	${CCHELPER_ENABLE_WARNINGS}
)

if (ENABLE_WARNINGS)
	# search for supported and enabled languages
	get_property(ENABLED_LANGUAGES GLOBAL PROPERTY ENABLED_LANGUAGES)

	list(FIND ENABLED_LANGUAGES "C" LANG_C_ENABLED)
	if (${LANG_C_ENABLED} EQUAL 0)
		list(APPEND languages C)
	endif ()

	list(FIND ENABLED_LANGUAGES "CXX" LANG_CXX_ENABLED)
	if (${LANG_CXX_ENABLED} EQUAL 0)
		list(APPEND languages CXX)
	endif ()


	# Enable warnings for compilers
	foreach (lang ${languages})
		if ("${CMAKE_${lang}_COMPILER_ID}" STREQUAL "Clang" OR
		    "${CMAKE_${lang}_COMPILER_ID}" STREQUAL "GNU" OR
		    "${CMAKE_${lang}_COMPILER_ID}" STREQUAL "Intel")
			set(CMAKE_${lang}_FLAGS "${CMAKE_${lang}_FLAGS} -Wall")

		elseif ("${CMAKE_${lang}_COMPILER_ID}" STREQUAL "MSVC")
			set(CMAKE_${lang}_FLAGS "${CMAKE_${lang}_FLAGS} /W3")

		else ()
			message(WARNING
				"Did not find a warning-flag for used ${lang} compiler.")
		endif ()
	endforeach()
endif (ENABLE_WARNINGS)


# Enable pedantic errors. A default option can be set via the
# CCHELPER_ENABLE_PEDANTIC variable. Set it before including this file.
if (NOT DEFINED CCHELPER_ENABLE_PEDANTIC)
	set(CCHELPER_ENABLE_PEDANTIC true)
endif ()

option(ENABLE_PEDANTIC
	"Selects whether pedantic warnings are enabled."
	${CCHELPER_ENABLE_PEDANTIC}
)

if (ENABLE_PEDANTIC)
	# search for supported and enabled languages
	get_property(ENABLED_LANGUAGES GLOBAL PROPERTY ENABLED_LANGUAGES)

	list(FIND ENABLED_LANGUAGES "C" LANG_C_ENABLED)
	if (${LANG_C_ENABLED} EQUAL 0)
		list(APPEND languages C)
	endif ()

	list(FIND ENABLED_LANGUAGES "CXX" LANG_CXX_ENABLED)
	if (${LANG_CXX_ENABLED} EQUAL 0)
		list(APPEND languages CXX)
	endif ()


	# Enable warnings for compilers
	foreach (lang ${languages})
		if ("${CMAKE_${lang}_COMPILER_ID}" STREQUAL "Clang" OR
		    "${CMAKE_${lang}_COMPILER_ID}" STREQUAL "GNU" OR
		    "${CMAKE_${lang}_COMPILER_ID}" STREQUAL "Intel")
			set(CMAKE_${lang}_FLAGS "${CMAKE_${lang}_FLAGS} -pedantic")

		else ()
			message(WARNING
			"Did not find a pedantic-flag for used ${lang} compiler.")
		endif ()
	endforeach()
endif (ENABLE_PEDANTIC)
