FROM ubuntu:24.04

RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt install -y \
    automake autopoint wget libtool libblkid-dev \
    cmake git libdrm-dev build-essential python3-pip python3-venv \
    flex bison nasm libunwind-dev libselinux1-dev \
    libx11-dev libxv-dev libxt-dev libx11-xcb-dev libxi-dev \
    libmount-dev libdw-dev libssl-dev libxext-dev libxau-dev \
    libbz2-dev libffi-dev pkg-config libgl-dev libzstd-dev 

# Change shell to bash so the source command works
SHELL ["/bin/bash", "-c"]

RUN python3 -m venv /mesonvenv && \
    source /mesonvenv/bin/activate && pip install meson ninja

ARG PACKAGE_CONTACT
ARG OUTPUT_DIR
RUN mkdir -p $OUTPUT_DIR

RUN git clone --branch v1.5.3 https://github.com/Haivision/srt.git /workspace/thirdparty/srt
RUN git clone --branch 2.81.2 https://github.com/GNOME/glib.git /workspace/thirdparty/glib
RUN git clone --branch 1.24.7 https://github.com/GStreamer/gstreamer.git /workspace/thirdparty/gstreamer

###########################
## Build srt ------- 
WORKDIR /workspace/thirdparty/srt

RUN cmake . -B ./build -DENABLE_STATIC=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=./install
RUN cmake --build build --target install
RUN cp -r ./install/* /usr/local/ && ldconfig

RUN LATEST_TAG=$(git describe --tags --exact-match) && \
    REPOSITORY_NAME=$(basename $(git rev-parse --show-toplevel)) && \
    cpack -G TGZ -B ${OUTPUT_DIR} \
    -D CPACK_INSTALLED_DIRECTORIES="$(pwd)/install;." \
    -D CPACK_PACKAGE_VERSION="${LATEST_TAG}" \
    -D CPACK_PACKAGE_DESCRIPTION="${REPOSITORY_NAME}" \
    -D CPACK_PACKAGE_FILE_NAME="${REPOSITORY_NAME}-${LATEST_TAG}" \
    -D CPACK_PACKAGE_NAME="${REPOSITORY_NAME}" \
    -D CPACK_PACKAGE_CONTACT="${PACKAGE_CONTACT}"

###########################
## Build glib ------- 
WORKDIR /workspace/thirdparty/glib

RUN source /mesonvenv/bin/activate && meson setup --prefix=$(pwd)/install --default-library=static build
RUN source /mesonvenv/bin/activate && meson compile -C build
RUN source /mesonvenv/bin/activate && meson install -C build

RUN LATEST_TAG=$(git describe --tags --exact-match) && \
    REPOSITORY_NAME=$(basename $(git rev-parse --show-toplevel)) && \
    cpack -G TGZ -B ${OUTPUT_DIR} \
    -D CPACK_INSTALLED_DIRECTORIES="$(pwd)/install;." \
    -D CPACK_PACKAGE_VERSION="${LATEST_TAG}" \
    -D CPACK_PACKAGE_DESCRIPTION="${REPOSITORY_NAME}" \
    -D CPACK_PACKAGE_FILE_NAME="${REPOSITORY_NAME}-${LATEST_TAG}" \
    -D CPACK_PACKAGE_NAME="${REPOSITORY_NAME}" \
    -D CPACK_PACKAGE_CONTACT="${PACKAGE_CONTACT}"

#RUN rm -rf ./install ./build

##########################
# Build gstreamer ------- 
WORKDIR /workspace/thirdparty/gstreamer

#RUN /bin/bash -c \
#    "source /mesonvenv/bin/activate && meson setup --reconfigure build && rm -rf build"
RUN source /mesonvenv/bin/activate && pip install setuptools
RUN source /mesonvenv/bin/activate && export PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/share/pkgconfig && meson setup --prefix=$(pwd)/install --default-library=static -Dtests=disabled -Dexamples=disabled -Dintrospection=disabled -Dgst-plugins-base:gl=enabled -Dgst-plugins-good:ximagesrc=enabled -Dgst-plugins-bad:d3d11=enabled -Dgst-plugins-bad:srt=enabled build
RUN source /mesonvenv/bin/activate && meson compile -C build
RUN source /mesonvenv/bin/activate && meson install -C build

RUN LATEST_TAG=$(git describe --tags --exact-match) && \
    REPOSITORY_NAME=$(basename $(git rev-parse --show-toplevel)) && \
    cpack -G TGZ -B ${OUTPUT_DIR} \
    -D CPACK_INSTALLED_DIRECTORIES="$(pwd)/install;." \
    -D CPACK_PACKAGE_VERSION="${LATEST_TAG}" \
    -D CPACK_PACKAGE_DESCRIPTION="${REPOSITORY_NAME}" \
    -D CPACK_PACKAGE_FILE_NAME="${REPOSITORY_NAME}-${LATEST_TAG}" \
    -D CPACK_PACKAGE_NAME="${REPOSITORY_NAME}" \
    -D CPACK_PACKAGE_CONTACT="${PACKAGE_CONTACT}"

WORKDIR /workspace

RUN wget https://www.kernel.org/pub/linux/utils/util-linux/v2.39/util-linux-2.39.1.tar.xz
RUN tar -xvf util-linux-2.39.1.tar.xz

WORKDIR /workspace/util-linux-2.39.1

RUN ./autogen.sh
RUN ./configure --enable-static --disable-shared --without-python CFLAGS="-fPIC" CXXFLAGS="-fPIC"
RUN make
RUN make install
RUN cp -r /workspace/util-linux-2.39.1 $OUTPUT_DIR/

WORKDIR /workspace
RUN git clone --branch https://sourceware.org/git/elfutils.git /workspace/elfutils-0.191
RUN export DEBIAN_FRONTEND=noninteractive && apt update && apt install -y \
    gawk

WORKDIR /workspace/elfutils-0.191

RUN export CFLAGS="-fPIC" && autoreconf -i --force && ./configure CFLAGS="-fPIC" --enable-maintainer-mode && make
RUN make install
RUN cp -r /workspace/elfutils-0.191 $OUTPUT_DIR/

#WORKDIR /workspace
#
#RUN git clone https://github.com/godotengine/godot-cpp.git /workspace/godot-cpp --branch godot-4.3-stable
#RUN cmake -DCMAKE_BUILD_TYPE=Release ./godot-cpp -B ./godot-cpp/build
#RUN cmake --build ./godot-cpp/build
#
#COPY ./include              /workspace/include
#COPY ./src                  /workspace/src
#COPY ./tests                /workspace/tests
#COPY ./CMakeLists.txt       /workspace/CMakeLists.txt
#
#RUN cmake ./ -B ./build \
#    -DCPP_BINDINGS_PATH=./godot-cpp \
#    -DGODOT_GDEXTENSION_DIR=./godot-cpp/gdextension/ \
#    -DGLIB_PATH=$(pwd)/thirdparty/glib/install \
#    -DSRT_PATH=$(pwd)/thirdparty/srt/install \
#    -DGSTREAMER_PATH=$(pwd)/thirdparty/gstreamer/install \
#    -DCMAKE_BUILD_TYPE=Release
#RUN cmake --build ./build
#
#RUN mv ./bin/x11 $OUTPUT_DIR

CMD ["tail", "-f", "/dev/null"]