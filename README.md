## GDGstService

Gstreamer extension for godot. GStreamer can be used in order to receive camera streams from remote devices.

### Demo Preview

![Demo Preview](demo.gif)

### Dependencies:

If you compile the extension with dynamic gstream libs (E.g. `./build_gd_gst.sh  
--godot-cpp-path=./godot-cpp` ) the following dependencies are required:

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

### Run example
Before importing the example project.godot you need to build and install the extension by executing

    ./setup_example.sh

Then run a corresponding srt stream.

Option 1: Run a stream using gst-launch and a video device:

    gst-launch-1.0 -v v4l2src device=/dev/video0 ! videoconvert ! \
      x264enc bitrate=4000 tune=zerolatency speed-preset=superfast ! video/x-h264, profile=baseline ! \
      mpegtsmux ! srtsink uri=srt://:8888 latency=100

Option 2: Alternatively use gst-launch and a video file src:

    gst-launch-1.0 -v filesrc location=/path/to/video.mp4 ! decodebin ! videoconvert ! \
        x264enc bitrate=4000 tune=zerolatency speed-preset=superfast ! video/x-h264, profile=baseline ! \
        mpegtsmux ! srtsink uri=srt://:8888 latency=100 

Import the example `project.godot` and run in debug.

### Custom setup
Install the dependencies. Build the extentension 
    
    ./build_gd_gst.sh  --godot-cpp-path=path/to/godot-cpp (version 4.3 tested on Ubuntu 20.04) 

and install it in your custom environment.
