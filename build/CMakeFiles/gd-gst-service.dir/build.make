# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.28

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:

#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:

# Disable VCS-based implicit rules.
% : %,v

# Disable VCS-based implicit rules.
% : RCS/%

# Disable VCS-based implicit rules.
% : RCS/%,v

# Disable VCS-based implicit rules.
% : SCCS/s.%

# Disable VCS-based implicit rules.
% : s.%

.SUFFIXES: .hpux_make_needs_suffix_list

# Command-line flag to silence nested $(MAKE).
$(VERBOSE)MAKESILENT = -s

#Suppress display of executed commands.
$(VERBOSE).SILENT:

# A target that is always out of date.
cmake_force:
.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E rm -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/avk/Projects/workspace_gd/gd_gst_service

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/avk/Projects/workspace_gd/gd_gst_service/build

# Include any dependencies generated for this target.
include CMakeFiles/gd-gst-service.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/gd-gst-service.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/gd-gst-service.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/gd-gst-service.dir/flags.make

CMakeFiles/gd-gst-service.dir/src/gd_gst_service.cpp.o: CMakeFiles/gd-gst-service.dir/flags.make
CMakeFiles/gd-gst-service.dir/src/gd_gst_service.cpp.o: /home/avk/Projects/workspace_gd/gd_gst_service/src/gd_gst_service.cpp
CMakeFiles/gd-gst-service.dir/src/gd_gst_service.cpp.o: CMakeFiles/gd-gst-service.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/avk/Projects/workspace_gd/gd_gst_service/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/gd-gst-service.dir/src/gd_gst_service.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/gd-gst-service.dir/src/gd_gst_service.cpp.o -MF CMakeFiles/gd-gst-service.dir/src/gd_gst_service.cpp.o.d -o CMakeFiles/gd-gst-service.dir/src/gd_gst_service.cpp.o -c /home/avk/Projects/workspace_gd/gd_gst_service/src/gd_gst_service.cpp

CMakeFiles/gd-gst-service.dir/src/gd_gst_service.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/gd-gst-service.dir/src/gd_gst_service.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/avk/Projects/workspace_gd/gd_gst_service/src/gd_gst_service.cpp > CMakeFiles/gd-gst-service.dir/src/gd_gst_service.cpp.i

CMakeFiles/gd-gst-service.dir/src/gd_gst_service.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/gd-gst-service.dir/src/gd_gst_service.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/avk/Projects/workspace_gd/gd_gst_service/src/gd_gst_service.cpp -o CMakeFiles/gd-gst-service.dir/src/gd_gst_service.cpp.s

CMakeFiles/gd-gst-service.dir/src/gst_service/gst_service.cpp.o: CMakeFiles/gd-gst-service.dir/flags.make
CMakeFiles/gd-gst-service.dir/src/gst_service/gst_service.cpp.o: /home/avk/Projects/workspace_gd/gd_gst_service/src/gst_service/gst_service.cpp
CMakeFiles/gd-gst-service.dir/src/gst_service/gst_service.cpp.o: CMakeFiles/gd-gst-service.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/avk/Projects/workspace_gd/gd_gst_service/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building CXX object CMakeFiles/gd-gst-service.dir/src/gst_service/gst_service.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/gd-gst-service.dir/src/gst_service/gst_service.cpp.o -MF CMakeFiles/gd-gst-service.dir/src/gst_service/gst_service.cpp.o.d -o CMakeFiles/gd-gst-service.dir/src/gst_service/gst_service.cpp.o -c /home/avk/Projects/workspace_gd/gd_gst_service/src/gst_service/gst_service.cpp

CMakeFiles/gd-gst-service.dir/src/gst_service/gst_service.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/gd-gst-service.dir/src/gst_service/gst_service.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/avk/Projects/workspace_gd/gd_gst_service/src/gst_service/gst_service.cpp > CMakeFiles/gd-gst-service.dir/src/gst_service/gst_service.cpp.i

CMakeFiles/gd-gst-service.dir/src/gst_service/gst_service.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/gd-gst-service.dir/src/gst_service/gst_service.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/avk/Projects/workspace_gd/gd_gst_service/src/gst_service/gst_service.cpp -o CMakeFiles/gd-gst-service.dir/src/gst_service/gst_service.cpp.s

CMakeFiles/gd-gst-service.dir/src/register_types.cpp.o: CMakeFiles/gd-gst-service.dir/flags.make
CMakeFiles/gd-gst-service.dir/src/register_types.cpp.o: /home/avk/Projects/workspace_gd/gd_gst_service/src/register_types.cpp
CMakeFiles/gd-gst-service.dir/src/register_types.cpp.o: CMakeFiles/gd-gst-service.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/home/avk/Projects/workspace_gd/gd_gst_service/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building CXX object CMakeFiles/gd-gst-service.dir/src/register_types.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/gd-gst-service.dir/src/register_types.cpp.o -MF CMakeFiles/gd-gst-service.dir/src/register_types.cpp.o.d -o CMakeFiles/gd-gst-service.dir/src/register_types.cpp.o -c /home/avk/Projects/workspace_gd/gd_gst_service/src/register_types.cpp

CMakeFiles/gd-gst-service.dir/src/register_types.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/gd-gst-service.dir/src/register_types.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/avk/Projects/workspace_gd/gd_gst_service/src/register_types.cpp > CMakeFiles/gd-gst-service.dir/src/register_types.cpp.i

CMakeFiles/gd-gst-service.dir/src/register_types.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/gd-gst-service.dir/src/register_types.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/avk/Projects/workspace_gd/gd_gst_service/src/register_types.cpp -o CMakeFiles/gd-gst-service.dir/src/register_types.cpp.s

# Object files for target gd-gst-service
gd__gst__service_OBJECTS = \
"CMakeFiles/gd-gst-service.dir/src/gd_gst_service.cpp.o" \
"CMakeFiles/gd-gst-service.dir/src/gst_service/gst_service.cpp.o" \
"CMakeFiles/gd-gst-service.dir/src/register_types.cpp.o"

# External object files for target gd-gst-service
gd__gst__service_EXTERNAL_OBJECTS =

/home/avk/Projects/workspace_gd/gd_gst_service/bin/x11/libgd-gst-service.release.so: CMakeFiles/gd-gst-service.dir/src/gd_gst_service.cpp.o
/home/avk/Projects/workspace_gd/gd_gst_service/bin/x11/libgd-gst-service.release.so: CMakeFiles/gd-gst-service.dir/src/gst_service/gst_service.cpp.o
/home/avk/Projects/workspace_gd/gd_gst_service/bin/x11/libgd-gst-service.release.so: CMakeFiles/gd-gst-service.dir/src/register_types.cpp.o
/home/avk/Projects/workspace_gd/gd_gst_service/bin/x11/libgd-gst-service.release.so: CMakeFiles/gd-gst-service.dir/build.make
/home/avk/Projects/workspace_gd/gd_gst_service/bin/x11/libgd-gst-service.release.so: CMakeFiles/gd-gst-service.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=/home/avk/Projects/workspace_gd/gd_gst_service/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Linking CXX shared library /home/avk/Projects/workspace_gd/gd_gst_service/bin/x11/libgd-gst-service.release.so"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/gd-gst-service.dir/link.txt --verbose=$(VERBOSE)
	/usr/bin/cmake -E copy /home/avk/Projects/workspace_gd/gd_gst_service/bin/x11/libgd-gst-service.release.so /home/avk/Projects/workspace_gd/gd_gst_service/bin/x11/libgd-gst-service.debug.so

# Rule to build all files generated by this target.
CMakeFiles/gd-gst-service.dir/build: /home/avk/Projects/workspace_gd/gd_gst_service/bin/x11/libgd-gst-service.release.so
.PHONY : CMakeFiles/gd-gst-service.dir/build

CMakeFiles/gd-gst-service.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/gd-gst-service.dir/cmake_clean.cmake
.PHONY : CMakeFiles/gd-gst-service.dir/clean

CMakeFiles/gd-gst-service.dir/depend:
	cd /home/avk/Projects/workspace_gd/gd_gst_service/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/avk/Projects/workspace_gd/gd_gst_service /home/avk/Projects/workspace_gd/gd_gst_service /home/avk/Projects/workspace_gd/gd_gst_service/build /home/avk/Projects/workspace_gd/gd_gst_service/build /home/avk/Projects/workspace_gd/gd_gst_service/build/CMakeFiles/gd-gst-service.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : CMakeFiles/gd-gst-service.dir/depend

