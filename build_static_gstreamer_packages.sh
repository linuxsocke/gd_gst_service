#!/bin/bash

# Display usage message
usage() {
  echo "Usage: $0 --package-contact=contact --linux-distro]"
  exit 1
}

# Initialize variables
PACKAGE_CONTACT=""
LINUX_DISTRO=""

# Extract arguments and values
for arg in "$@"
do
  case $arg in
    --package-contact=*)
    PACKAGE_CONTACT="${arg#*=}"
    shift
    ;;
    --linux-distro=*)
    LINUX_DISTRO="${arg#*=}"
    shift
    ;;
    *)
    echo "Error: Unknown argument."
    usage
    ;;
  esac
done

if [ -z "$PACKAGE_CONTACT" ]; then
  echo "Error: --package-contact is required."
  usage
fi
if [ -z "$LINUX_DISTRO" ]; then
  echo "Error: --linux-distro is required."
  usage
fi

echo -e "\e[1;34mBuilding gd_gst_service for LINUX_DISTRO=$LINUX_DISTRO\e[0m"

OUTPUT_DIR=/thirdparty

dockerfile=""
if [[ $LINUX_DISTRO == "noble" ]]; then
    dockerfile="ubuntu_24.04_build.dockerfile"
elif [[ $LINUX_DISTRO == "jammy" ]]; then
    dockerfile="ubuntu_22.04_build.dockerfile"
elif [[ $LINUX_DISTRO == "focal" ]]; then
    dockerfile="ubuntu_20.04_build.dockerfile"
else
    exit 1
fi

docker build --file ./$dockerfile --build-arg PACKAGE_CONTACT=$PACKAGE_CONTACT --build-arg OUTPUT_DIR=$OUTPUT_DIR/$LINUX_DISTRO --progress=plain -t package_builder .
if [ $? -ne 0 ]; then
  docker image rm -f package_builder
  echo -e "\e[1;31mFailed building dockerfile.\e[0m" 
  exit 1
fi
docker run --name package_builder -d package_builder
if [ $? == 0 ]; then
  docker cp package_builder:$OUTPUT_DIR .
  rm -rf .$OUTPUT_DIR/$LINUX_DISTRO/_CPack_Packages
fi
docker stop package_builder
docker rm package_builder
docker image rm -f package_builder

cd .$OUTPUT_DIR/$LINUX_DISTRO
for file in *.tar.gz; do tar -xzf "$file"; done
echo -e "Packages extracted."
echo -e "\e[1;34mFinished creating packages.\e[0m"