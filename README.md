## GDGstService

### Dependencies:
  - cmake 
  - git
  - gstreamer1.0-libav
  - gstreamer1.0-plugins-bad
  - gstreamer1.0-plugins-base
  - gstreamer1.0-plugins-good
  - gstreamer1.0-plugins-ugly
  - gstreamer1.0-tools 
  - libgstreamer1.0-dev
  - libgstreamer-plugins-base1.0-dev
  - libgstreamer-plugins-good1.0-0

### Setup example
Before importing the gd_stream_example you need to execute 

    ./setup_example.sh

in order to build and install the required gd_extension.

### Custom setup
Install the dependencies. Build the extentension 
    
    ./build_gd_gst.sh  --godot-cpp-path=path/to/godot-cpp (version 4.3 tested) 

and install it in your custom environment.
