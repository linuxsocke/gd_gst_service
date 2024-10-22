cmake_minimum_required(VERSION 3.6)
project(gd-gst-service)

if(DEFINED GODOT_CPP_PATH)
	set(GODOT_CPP_PATH ${GODOT_CPP_PATH} CACHE STRING "Path to C++ bindings")
else()
	set(GODOT_CPP_PATH godot-cpp CACHE STRING "Path to C++ bindings")
endif()
message(STATUS "GODOT_CPP_PATH: ${GODOT_CPP_PATH}")

set(GODOT_GDEXTENSION_DIR ${GODOT_CPP_PATH}/gdextension/ CACHE STRING "Path to GDExtension interface header directory")

if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
	set(TARGET_PATH x11)
	set(LIB_EXT ".so")
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows")
	set(TARGET_PATH win64)
	set(LIB_EXT ".dll")

elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
	set(TARGET_PATH macos)
	set(LIB_EXT ".dylib")

else()
	message(FATAL_ERROR "Not implemented support for ${CMAKE_SYSTEM_NAME}")
endif()

message(STATUS "Configured support for ${CMAKE_SYSTEM_NAME} system.")

# Change the output directory to the bin directory
set(BUILD_PATH ${CMAKE_SOURCE_DIR}/bin/${TARGET_PATH})
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${BUILD_PATH}")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${BUILD_PATH}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${BUILD_PATH}")
SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG "${BUILD_PATH}")
SET(CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE "${BUILD_PATH}")
SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY_DEBUG "${BUILD_PATH}")
SET(CMAKE_LIBRARY_OUTPUT_DIRECTORY_RELEASE "${BUILD_PATH}")
SET(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_DEBUG "${BUILD_PATH}")
SET(CMAKE_ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${BUILD_PATH}")

# Set the c++ standard to c++20
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIC")

set(GODOT_COMPILE_FLAGS )
set(GODOT_LINKER_FLAGS )

add_compile_options(-Wall -Wextra -Wpedantic -Werror -Wno-error=switch-enum)

if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
	# using Visual Studio C++
	set(GODOT_COMPILE_FLAGS "${GODOT_COMPILE_FLAGS} /WX") # /GF /MP
	set(GODOT_COMPILE_FLAGS "${GODOT_COMPILE_FLAGS} /DTYPED_METHOD_BIND")

	if(CMAKE_BUILD_TYPE MATCHES Debug)
		set(GODOT_COMPILE_FLAGS "${GODOT_COMPILE_FLAGS} /MDd") # /Od /RTC1 /Zi
	else()
		set(GODOT_COMPILE_FLAGS "${GODOT_COMPILE_FLAGS} /MD /O2") # /Oy /GL /Gy
		STRING(REGEX REPLACE "/RTC(su|[1su])" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
		string(REPLACE "/RTC1" "" CMAKE_CXX_FLAGS_DEBUG ${CMAKE_CXX_FLAGS_DEBUG})
	endif(CMAKE_BUILD_TYPE MATCHES Debug)

	# Disable conversion warning, truncation, unreferenced var, signed mismatch
	set(GODOT_COMPILE_FLAGS "${GODOT_COMPILE_FLAGS} /wd4244 /wd4305 /wd4101 /wd4018 /wd4267")

	add_definitions(-DNOMINMAX)

	# Unkomment for warning level 4
	#if(CMAKE_CXX_FLAGS MATCHES "/W[0-4]")
	#	string(REGEX REPLACE "/W[0-4]" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
	#endif()

else()

#elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
	# using Clang
#elseif ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
	# using GCC and maybe MinGW?

	if(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
		set(GODOT_LINKER_FLAGS "-Wl")
	else()
		set(GODOT_LINKER_FLAGS "-static-libgcc -static-libstdc++ -Wl,-R,'$$ORIGIN'")
	endif()

	# Hmm.. maybe to strikt?
	set(GODOT_COMPILE_FLAGS "-fPIC -g -Wwrite-strings")
	set(GODOT_COMPILE_FLAGS "${GODOT_COMPILE_FLAGS} -Wchar-subscripts -Wcomment -Wdisabled-optimization")
	set(GODOT_COMPILE_FLAGS "${GODOT_COMPILE_FLAGS} -Wformat -Wformat=2 -Wformat-security -Wformat-y2k")
	set(GODOT_COMPILE_FLAGS "${GODOT_COMPILE_FLAGS} -Wimport -Winit-self -Winline -Winvalid-pch -Werror")
	set(GODOT_COMPILE_FLAGS "${GODOT_COMPILE_FLAGS} -Wmissing-braces -Wmissing-format-attribute")
	set(GODOT_COMPILE_FLAGS "${GODOT_COMPILE_FLAGS} -Wmissing-include-dirs -Wmissing-noreturn -Wpacked -Wpointer-arith")
	set(GODOT_COMPILE_FLAGS "${GODOT_COMPILE_FLAGS} -Wredundant-decls -Wreturn-type -Wsequence-point")
	set(GODOT_COMPILE_FLAGS "${GODOT_COMPILE_FLAGS} -Wswitch -Wswitch-enum -Wtrigraphs")
	set(GODOT_COMPILE_FLAGS "${GODOT_COMPILE_FLAGS} -Wuninitialized -Wunknown-pragmas -Wunreachable-code -Wunused-label")
	set(GODOT_COMPILE_FLAGS "${GODOT_COMPILE_FLAGS} -Wunused-value -Wvariadic-macros -Wvolatile-register-var -Wno-error=attributes")

	# -Wshadow -Wextra -Wall -Weffc++ -Wfloat-equal -Wstack-protector -Wunused-parameter -Wsign-compare -Wunused-variable -Wcast-align
	# -Wunused-function -Wstrict-aliasing -Wstrict-aliasing=2 -Wmissing-field-initializers

	if(NOT CMAKE_SYSTEM_NAME STREQUAL "Android")
		set(GODOT_COMPILE_FLAGS "${GODOT_COMPILE_FLAGS} -Wno-ignored-attributes")
	endif()

	if(CMAKE_BUILD_TYPE MATCHES Debug)
		set(GODOT_COMPILE_FLAGS "${GODOT_COMPILE_FLAGS} -fno-omit-frame-pointer -O0")
	else()
		set(GODOT_COMPILE_FLAGS "${GODOT_COMPILE_FLAGS} -O3")
	endif(CMAKE_BUILD_TYPE MATCHES Debug)
endif()

# Disable exception handling. Godot doesn't use exceptions anywhere, and this
# saves around 20% of binary size and very significant build time (GH-80513).
option(GODOT_DISABLE_EXCEPTIONS OFF "Force disabling exception handling code")
if (GODOT_DISABLE_EXCEPTIONS)
	if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
		set(GODOT_COMPILE_FLAGS "${GODOT_COMPILE_FLAGS} -D_HAS_EXCEPTIONS=0")
	else()
		set(GODOT_COMPILE_FLAGS "${GODOT_COMPILE_FLAGS} -fno-exceptions")
	endif()
else()
	if ("${CMAKE_CXX_COMPILER_ID}" STREQUAL "MSVC")
		set(GODOT_COMPILE_FLAGS "${GODOT_COMPILE_FLAGS} /EHsc")
	endif()
endif()

##################################################################################

##################################################################################
##################################################################################
if(DEFINED STATIC_GSTREAMER)
	##################################################################################
	add_definitions(-DSTATIC_GSTREAMER=ON)

	if(DEFINED GLIB_PATH)
		set(GLIB_PATH ${GLIB_PATH} CACHE STRING "Path to GLIB")
	else()
		set(GLIB_PATH ${CMAKE_SOURCE_DIR}/packages/glib/install CACHE STRING "Path to GLIB")
	endif()
	message(STATUS "GLIB_PATH: ${GLIB_PATH}")

	if(DEFINED SRT_PATH)
		set(SRT_PATH ${SRT_PATH} CACHE STRING "Path to SRT")
	else()
		set(SRT_PATH ${CMAKE_SOURCE_DIR}/packages/srt/install CACHE STRING "Path to SRT")
	endif()
	message(STATUS "SRT_PATH: ${SRT_PATH}")

	if(DEFINED LIBS_LINUX_UTILS)
		set(LIBS_LINUX_UTILS ${LIBS_LINUX_UTILS} CACHE STRING "Path to libmount")
	else()
		set(LIBS_LINUX_UTILS -lmount CACHE STRING "Libmount")
	endif()
	message(STATUS "LIBS_LINUX_UTILS: ${LIBS_LINUX_UTILS}")

	if(DEFINED GSTREAMER_PATH)
		set(GSTREAMER_PATH ${GSTREAMER_PATH} CACHE STRING "Path to GSTREAMER")
	else()
		set(GSTREAMER_PATH ${CMAKE_SOURCE_DIR}/packages/gstreamer/install CACHE STRING "Path to GSTREAMER")
	endif()
	message(STATUS "GSTREAMER_PATH: ${GSTREAMER_PATH}")
	# Define static linking
	#set(CMAKE_EXE_LINKER_FLAGS "-static")
	set(GLIB_INCLUDE_DIRS 
		"${GLIB_PATH}/lib/x86_64-linux-gnu/glib-2.0/include"
		"${GLIB_PATH}/include/glib-2.0"
	)
	set(GLIB_LIB_DIR "${GLIB_PATH}/lib/x86_64-linux-gnu")

	set(SRT_INCLUDE_DIRS 
		"${SRT_PATH}/include"
	)
	set(SRT_LIB_DIR "${SRT_PATH}/lib")

	# Set GStreamer paths
	set(GSTREAMER_INCLUDE_DIRS_STATIC
		"${GSTREAMER_PATH}/include/gstreamer-1.0"
		"${GSTREAMER_PATH}/include/orc-0.4"
	)
	set(GSTREAMER_LIB_DIR "${GSTREAMER_PATH}/lib/x86_64-linux-gnu")
	set(GSTREAMER_LIBRARIES_STATIC
		${GSTREAMER_LIB_DIR}/gstreamer-1.0/libgstcoreelements.a
		${GSTREAMER_LIB_DIR}/gstreamer-1.0/libgstplayback.a
		${GSTREAMER_LIB_DIR}/gstreamer-1.0/libgstvideoconvertscale.a
		${GSTREAMER_LIB_DIR}/gstreamer-1.0/libgstautodetect.a
		${GSTREAMER_LIB_DIR}/gstreamer-1.0/libgstapp.a
		${GSTREAMER_LIB_DIR}/gstreamer-1.0/libgstximagesink.a
		${GSTREAMER_LIB_DIR}/gstreamer-1.0/libgsttypefindfunctions.a
		${GSTREAMER_LIB_DIR}/gstreamer-1.0/libgstsrt.a
		${GSTREAMER_LIB_DIR}/gstreamer-1.0/libgstmpegtsdemux.a
		${GSTREAMER_LIB_DIR}/gstreamer-1.0/libgstvideoparsersbad.a
		${GSTREAMER_LIB_DIR}/gstreamer-1.0/libgstopenh264.a
		${GSTREAMER_LIB_DIR}/libgstreamer-1.0.a
		${GSTREAMER_LIB_DIR}/libgstapp-1.0.a
		${GSTREAMER_LIB_DIR}/libgstvideo-1.0.a
		${GSTREAMER_LIB_DIR}/libgstpbutils-1.0.a
		${GSTREAMER_LIB_DIR}/libgstcodecparsers-1.0.a
		${GSTREAMER_LIB_DIR}/libgstbase-1.0.a
		${GSTREAMER_LIB_DIR}/libgstaudio-1.0.a
		${GSTREAMER_LIB_DIR}/libgsttag-1.0.a
		${GSTREAMER_LIB_DIR}/libgstfft-1.0.a
		${GSTREAMER_LIB_DIR}/libgstgl-1.0.a
		${GSTREAMER_LIB_DIR}/libgstallocators-1.0.a
		${GSTREAMER_LIB_DIR}/libgstriff-1.0.a
		${GSTREAMER_LIB_DIR}/libgstcontroller-1.0.a
		${GSTREAMER_LIB_DIR}/libgstmpegts-1.0.a
		${GSTREAMER_LIB_DIR}/libgstrtp-1.0.a
		${GSTREAMER_LIB_DIR}/libgstnet-1.0.a
		${GSTREAMER_LIB_DIR}/liborc-0.4.a
		${GSTREAMER_LIB_DIR}/libopenh264.a
		${GLIB_LIB_DIR}/libgio-2.0.a
		${GLIB_LIB_DIR}/libgmodule-2.0.a
		${GLIB_LIB_DIR}/libgobject-2.0.a
		${GLIB_LIB_DIR}/libglib-2.0.a
		${SRT_LIB_DIR}/libsrt.a
		${LIBS_LINUX_UTILS}/libmount.a
		${LIBS_LINUX_UTILS}/libblkid.a
		/mnt/0032e22d-a59b-47c8-95c7-1565d20b2df2/Projects/workspace_gd/tea_app_v2/gd_extensions/gd_gst_service/packages/noble/elfutils/lib/libeu.a
		/mnt/0032e22d-a59b-47c8-95c7-1565d20b2df2/Projects/workspace_gd/tea_app_v2/gd_extensions/gd_gst_service/packages/noble/elfutils/libdw/libdw.a
		/mnt/0032e22d-a59b-47c8-95c7-1565d20b2df2/Projects/workspace_gd/tea_app_v2/gd_extensions/gd_gst_service/packages/noble/elfutils/libelf/libelf.a
		###########
		/usr/lib/x86_64-linux-gnu/libssl.a
		/usr/lib/x86_64-linux-gnu/libcrypto.a
		#-lssl -lcrypto 
		/usr/lib/gcc/x86_64-linux-gnu/13/libgcc_eh.a
		/usr/lib/x86_64-linux-gnu/libbz2.a
		/usr/lib/x86_64-linux-gnu/libunwind.a
		/usr/lib/x86_64-linux-gnu/libz.a
		/usr/lib/x86_64-linux-gnu/libm.a
		/usr/lib/x86_64-linux-gnu/libdl.a
		/usr/lib/x86_64-linux-gnu/libX11.a
		/usr/lib/x86_64-linux-gnu/libXi.a
		/usr/lib/x86_64-linux-gnu/libXext.a
		/usr/lib/x86_64-linux-gnu/libxcb.a
		/usr/lib/x86_64-linux-gnu/liblzma.a
		/usr/lib/x86_64-linux-gnu/libXau.a
		/usr/lib/x86_64-linux-gnu/libXdmcp.a
		/usr/lib/x86_64-linux-gnu/libpthread.a
		/usr/lib/x86_64-linux-gnu/libresolv.a
		/usr/lib/x86_64-linux-gnu/libffi.a
		/usr/lib/x86_64-linux-gnu/libpcre2-8.a
		/usr/lib/x86_64-linux-gnu/libzstd.a
		#/usr/lib/x86_64-linux-gnu/libselinux.a
		-lselinux
	)

	#list(APPEND GSTREAMER_INCLUDE_DIRS_STATIC ${LIBDL_INCLUDE_DIR})
	list(APPEND GSTREAMER_INCLUDE_DIRS_STATIC 
		${GLIB_INCLUDE_DIRS}
		${SRT_INCLUDE_DIRS} 
	)
	##################################################################################
else()
	##################################################################################
	### SHARED TEST
	find_package(Threads REQUIRED)
	find_package(PkgConfig REQUIRED)
	pkg_search_module(GLIB REQUIRED glib-2.0)
	pkg_check_modules(GOBJECT REQUIRED gobject-2.0)
	pkg_check_modules(GSTREAMER REQUIRED 
		gstreamer-1.0 
		gstreamer-app-1.0
		gstreamer-plugins-base-1.0
	)
	list(APPEND ${GSTREAMER_LIBRARIES} Threads::Threads)
	##################################################################################
endif()
##################################################################################
##################################################################################

##################################################################################

set(libgst_service gst-service)
add_library(${libgst_service} src/gst_service/gst_service.cpp)
target_include_directories(${libgst_service} SYSTEM PRIVATE
	${CMAKE_SOURCE_DIR}/include
	#${GSTREAMER_INCLUDE_DIRS_STATIC}
	${GSTREAMER_INCLUDE_DIRS}
)
target_link_libraries(${libgst_service} 
	#${GSTREAMER_LIBRARIES_STATIC}
	${GSTREAMER_LIBRARIES}
)

set(test_gst_service test_gst_service)
add_executable(${test_gst_service} tests/test_gst_service.cpp)
target_include_directories(${test_gst_service} SYSTEM PRIVATE
	${CMAKE_SOURCE_DIR}/include
	#${GSTREAMER_INCLUDE_DIRS_STATIC}
	${GSTREAMER_INCLUDE_DIRS}
)
target_link_libraries(${test_gst_service} 
	${libgst_service}
)
##################################################################################

# Get Sources
file(GLOB_RECURSE SOURCES src/*.c**)
file(GLOB_RECURSE HEADERS include/*.h**)

# Define our godot-cpp library
add_library(${PROJECT_NAME} SHARED ${SOURCES} ${HEADERS})

target_include_directories(${PROJECT_NAME} SYSTEM PRIVATE
	${CMAKE_SOURCE_DIR}/include
	${GODOT_CPP_PATH}/include
	${GODOT_CPP_PATH}/build/gen/include
	${GODOT_GDEXTENSION_DIR}
	#${GSTREAMER_INCLUDE_DIRS_STATIC}
	${GSTREAMER_INCLUDE_DIRS}
)


# Create the correct name (godot.os.build_type.system_bits)
# Synchronized with godot-cpp's CMakeLists.txt

set(BITS 32)
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
	set(BITS 64)
endif(CMAKE_SIZEOF_VOID_P EQUAL 8)

if(CMAKE_BUILD_TYPE MATCHES Debug)
	set(GODOT_CPP_BUILD_TYPE Debug)
else()
	set(GODOT_CPP_BUILD_TYPE Release)
endif()

string(TOLOWER ${CMAKE_SYSTEM_NAME} SYSTEM_NAME)
string(TOLOWER ${GODOT_CPP_BUILD_TYPE} BUILD_TYPE)

if(ANDROID)
	# Added the android abi after system name
	set(SYSTEM_NAME ${SYSTEM_NAME}.${ANDROID_ABI})
endif()

if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
	target_link_directories(${PROJECT_NAME}
		PRIVATE
		${GODOT_CPP_PATH}/bin/Debug # "Debug" Always seems to be a bug on Windows
	)
	target_link_libraries(${PROJECT_NAME}
		godot-cpp.${SYSTEM_NAME}.${BUILD_TYPE}$<$<NOT:$<PLATFORM_ID:Android>>:.${BITS}>
		#${GSTREAMER_LIBRARIES_STATIC}
		${GSTREAMER_LIBRARIES}
	)
else()
	target_link_directories(${PROJECT_NAME}
		PRIVATE
		${GODOT_CPP_PATH}/build/bin/
	)
	target_link_libraries(${PROJECT_NAME}
		libgodot-cpp.${SYSTEM_NAME}.${BUILD_TYPE}$<$<NOT:$<PLATFORM_ID:Android>>:.${BITS}>.a
		#${GSTREAMER_LIBRARIES_STATIC}
		${GSTREAMER_LIBRARIES}
	)
	#set(test_gd_gst_service test_gd_gst_service)
	#add_executable(${test_gd_gst_service} 
	#	tests/test_gd_gst_service.cpp
	#	${SOURCES}
	#)
	#target_link_directories(${test_gd_gst_service}
	#	PRIVATE
	#	${GODOT_CPP_PATH}/build/bin/
	#)
	#target_link_libraries(${test_gd_gst_service}
	#	libgodot-cpp.${SYSTEM_NAME}.${BUILD_TYPE}$<$<NOT:$<PLATFORM_ID:Android>>:.${BITS}>.a
	#	${GSTREAMER_LIBRARIES_STATIC}
	#)
	#target_include_directories(${test_gd_gst_service} SYSTEM PRIVATE
	#	${CMAKE_SOURCE_DIR}/include
	#	${GODOT_CPP_PATH}/include
	#	${GODOT_CPP_PATH}/build/gen/include
	#	${GODOT_GDEXTENSION_DIR}
	#	${GSTREAMER_INCLUDE_DIRS_STATIC}
	#)
endif()
	
# Add the compile flags
set_property(TARGET ${PROJECT_NAME} APPEND_STRING PROPERTY COMPILE_FLAGS ${GODOT_COMPILE_FLAGS})
set_property(TARGET ${PROJECT_NAME} APPEND_STRING PROPERTY LINK_FLAGS ${GODOT_LINKER_FLAGS})

if(CMAKE_BUILD_TYPE MATCHES Debug)
	set_property(TARGET ${PROJECT_NAME} PROPERTY OUTPUT_NAME "${PROJECT_NAME}.debug")
else()
	set_property(TARGET ${PROJECT_NAME} PROPERTY OUTPUT_NAME "${PROJECT_NAME}.release")
endif()

# Copy a fake debug
if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
	add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
		COMMAND ${CMAKE_COMMAND} -E copy ${BUILD_PATH}/${PROJECT_NAME}.release${LIB_EXT} ${BUILD_PATH}/${PROJECT_NAME}.debug${LIB_EXT}
	)
else()
	add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
		COMMAND ${CMAKE_COMMAND} -E copy ${BUILD_PATH}/lib${PROJECT_NAME}.release${LIB_EXT} ${BUILD_PATH}/lib${PROJECT_NAME}.debug${LIB_EXT}
	)
endif()
