#!/bin/bash

    #gstreamer1.0-libav \
sudo apt install cmake git \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-tools  \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    libgstreamer-plugins-good1.0-0 
if [ $? -ne 0 ]; then
    exit 1
fi

if [ ! -d "godot-cpp" ]; then
    git clone https://github.com/godotengine/godot-cpp.git godot-cpp --branch godot-4.3-stable
fi

cmake -DCMAKE_BUILD_TYPE=Release ./godot-cpp -B ./godot-cpp/build
cmake --build ./godot-cpp/build


./build_gd_gst.sh  --godot-cpp-path=./godot-cpp

if [ ! -d "addons/bin" ]; then
    mkdir -p addons/bin
fi
cp gdgstservice.gdextension ./addons/bin/
cp ./bin/x11/*.so ./addons/bin/
echo -e "\e[1;34mExample installed.\e[0m"