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
CMAKE_SOURCE_DIR = /mnt/0032e22d-a59b-47c8-95c7-1565d20b2df2/Projects/workspace_gd/gd_gst_service

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /mnt/0032e22d-a59b-47c8-95c7-1565d20b2df2/Projects/workspace_gd/gd_gst_service/build

# Include any dependencies generated for this target.
include CMakeFiles/gst-service.dir/depend.make
# Include any dependencies generated by the compiler for this target.
include CMakeFiles/gst-service.dir/compiler_depend.make

# Include the progress variables for this target.
include CMakeFiles/gst-service.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/gst-service.dir/flags.make

CMakeFiles/gst-service.dir/src/gst_service/gst_service.cpp.o: CMakeFiles/gst-service.dir/flags.make
CMakeFiles/gst-service.dir/src/gst_service/gst_service.cpp.o: /mnt/0032e22d-a59b-47c8-95c7-1565d20b2df2/Projects/workspace_gd/gd_gst_service/src/gst_service/gst_service.cpp
CMakeFiles/gst-service.dir/src/gst_service/gst_service.cpp.o: CMakeFiles/gst-service.dir/compiler_depend.ts
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --progress-dir=/mnt/0032e22d-a59b-47c8-95c7-1565d20b2df2/Projects/workspace_gd/gd_gst_service/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/gst-service.dir/src/gst_service/gst_service.cpp.o"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -MD -MT CMakeFiles/gst-service.dir/src/gst_service/gst_service.cpp.o -MF CMakeFiles/gst-service.dir/src/gst_service/gst_service.cpp.o.d -o CMakeFiles/gst-service.dir/src/gst_service/gst_service.cpp.o -c /mnt/0032e22d-a59b-47c8-95c7-1565d20b2df2/Projects/workspace_gd/gd_gst_service/src/gst_service/gst_service.cpp

CMakeFiles/gst-service.dir/src/gst_service/gst_service.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Preprocessing CXX source to CMakeFiles/gst-service.dir/src/gst_service/gst_service.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /mnt/0032e22d-a59b-47c8-95c7-1565d20b2df2/Projects/workspace_gd/gd_gst_service/src/gst_service/gst_service.cpp > CMakeFiles/gst-service.dir/src/gst_service/gst_service.cpp.i

CMakeFiles/gst-service.dir/src/gst_service/gst_service.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green "Compiling CXX source to assembly CMakeFiles/gst-service.dir/src/gst_service/gst_service.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /mnt/0032e22d-a59b-47c8-95c7-1565d20b2df2/Projects/workspace_gd/gd_gst_service/src/gst_service/gst_service.cpp -o CMakeFiles/gst-service.dir/src/gst_service/gst_service.cpp.s

# Object files for target gst-service
gst__service_OBJECTS = \
"CMakeFiles/gst-service.dir/src/gst_service/gst_service.cpp.o"

# External object files for target gst-service
gst__service_EXTERNAL_OBJECTS =

/mnt/0032e22d-a59b-47c8-95c7-1565d20b2df2/Projects/workspace_gd/gd_gst_service/bin/x11/libgst-service.a: CMakeFiles/gst-service.dir/src/gst_service/gst_service.cpp.o
/mnt/0032e22d-a59b-47c8-95c7-1565d20b2df2/Projects/workspace_gd/gd_gst_service/bin/x11/libgst-service.a: CMakeFiles/gst-service.dir/build.make
/mnt/0032e22d-a59b-47c8-95c7-1565d20b2df2/Projects/workspace_gd/gd_gst_service/bin/x11/libgst-service.a: CMakeFiles/gst-service.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color "--switch=$(COLOR)" --green --bold --progress-dir=/mnt/0032e22d-a59b-47c8-95c7-1565d20b2df2/Projects/workspace_gd/gd_gst_service/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX static library /mnt/0032e22d-a59b-47c8-95c7-1565d20b2df2/Projects/workspace_gd/gd_gst_service/bin/x11/libgst-service.a"
	$(CMAKE_COMMAND) -P CMakeFiles/gst-service.dir/cmake_clean_target.cmake
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/gst-service.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/gst-service.dir/build: /mnt/0032e22d-a59b-47c8-95c7-1565d20b2df2/Projects/workspace_gd/gd_gst_service/bin/x11/libgst-service.a
.PHONY : CMakeFiles/gst-service.dir/build

CMakeFiles/gst-service.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/gst-service.dir/cmake_clean.cmake
.PHONY : CMakeFiles/gst-service.dir/clean

CMakeFiles/gst-service.dir/depend:
	cd /mnt/0032e22d-a59b-47c8-95c7-1565d20b2df2/Projects/workspace_gd/gd_gst_service/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /mnt/0032e22d-a59b-47c8-95c7-1565d20b2df2/Projects/workspace_gd/gd_gst_service /mnt/0032e22d-a59b-47c8-95c7-1565d20b2df2/Projects/workspace_gd/gd_gst_service /mnt/0032e22d-a59b-47c8-95c7-1565d20b2df2/Projects/workspace_gd/gd_gst_service/build /mnt/0032e22d-a59b-47c8-95c7-1565d20b2df2/Projects/workspace_gd/gd_gst_service/build /mnt/0032e22d-a59b-47c8-95c7-1565d20b2df2/Projects/workspace_gd/gd_gst_service/build/CMakeFiles/gst-service.dir/DependInfo.cmake "--color=$(COLOR)"
.PHONY : CMakeFiles/gst-service.dir/depend

