#!/bin/bash
set -e

handle_default() {
echo "HANDLE DEFAULT"
	# if we have a Qt59 installation use it
if [ -f /opt/qt59/bin/qt59-env.sh ] ; then
	. /opt/qt59/bin/qt59-env.sh
fi

. /$LIBNAME/CI/travis/lib.sh

NUM_JOBS=4

mkdir -p build
echo "HERE"
pushd build
echo "HERE 2"
if [ "$TRAVIS" == "true" ] ; then
	echo "HERE3"
	cmake ..
	make -j${NUM_JOBS}
else
	echo "HERE4"
	cmake -DCMAKE_PREFIX_PATH="$STAGINGDIR;${QT_PATH}/lib/cmake" -DCMAKE_INSTALL_PREFIX="$STAGINGDIR" \
		-DCMAKE_EXE_LINKER_FLAGS="-L${STAGINGDIR}/lib" ..
	CFLAGS=-I${STAGINGDIR}/include LDFLAGS=-L${STAGINGDIR}/lib make -j${NUM_JOBS}
fi

popd
}

handle_ubuntu_docker() {
	echo "HANDLE docker"
	sudo docker run --rm=true \
			-v `pwd`:/scopy:rw \
			ubuntu:${OS_VERSION} \
			/bin/bash -xe /scopy/CI/travis/inside_ubuntu_docker.sh scopy
}

handle_ubuntu_flatpak_docker() {
	echo "HANDLE flatpak"
	sudo docker run --privileged --rm=true \
			-v `pwd`:/scopy:rw \
			alexandratr/ubuntu-flatpak-kde:latest \
			/bin/bash -xe /scopy/CI/travis/inside_ubuntu_flatpak_docker.sh
}

LIBNAME=${1:-home/travis/build/analogdevicesinc/scopy}
OS_TYPE=${2:-default}
OS_VERSION="$3"

handle_${OS_TYPE}
