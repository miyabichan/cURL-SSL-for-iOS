#!/bin/sh

#  Automatic build script for libcurl 
#  for iPhoneOS and iPhoneSimulator
#
#  Created by Miyabi Kazamatsuri on 19.04.11.
#  Copyright 2011 Miyabi Kazamatsuri. All rights reserved.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
###########################################################################
#  Change values here							  #
#									  #
VERSION="7.21.5"							  #
SDKVERSION="4.3"							  #
OPENSSL="${PWD}/../OpenSSL"							  #
#									  #
###########################################################################
#									  #
# Don't change anything under this line!				  #
#									  #
###########################################################################

CURRENTPATH=`pwd`

set -e
if [ ! -e libcurl-${VERSION}.tar.gz ]; then
	echo "Downloading curl-${VERSION}.tar.gz"
    curl -O http://curl.haxx.se/download/curl-${VERSION}.tar.gz
else
	echo "Using curl-${VERSION}.tar.gz"
fi

if [ -d  ${CURRENTPATH}/src ]; then
	rm -rf ${CURRENTPATH}/src
fi

if [ -d ${CURRENTPATH}/bin ]; then
	rm -rf ${CURRENTPATH}/bin
fi

mkdir -p "${CURRENTPATH}/src"
tar zxf curl-${VERSION}.tar.gz -C "${CURRENTPATH}/src"
cd "${CURRENTPATH}/src/curl-${VERSION}"

############
# iPhone Simulator
echo "Building libcurl for iPhoneSimulator ${SDKVERSION} i386"
echo "Please stand by..."

export CC="/Developer/Platforms/iPhoneSimulator.platform/Developer/usr/bin/gcc -arch i386"
export CFLAGS="-arch i386 -isysroot /Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator${SDKVERSION}.sdk -I${OPENSSL}/include -L${OPENSSL}"
mkdir -p "${CURRENTPATH}/bin/iPhoneSimulator${SDKVERSION}.sdk"

LOG="${CURRENTPATH}/bin/iPhoneSimulator${SDKVERSION}.sdk/build-libcurl-${VERSION}.log"

echo "Make libcurl for iPhoneSimulator ${SDKVERSION} i386"

./configure -prefix=${CURRENTPATH}/bin/iPhoneSimulator${SDKVERSION}.sdk --disable-shared -with-random=/dev/urandom --with-ssl > "${LOG}" 2>&1

make >> "${LOG}" 2>&1
make install >> "${LOG}" 2>&1
make clean >> "${LOG}" 2>&1

echo "Building libcurl for iPhoneSimulator ${SDKVERSION} i386, finished"
#############

#############
# iPhoneOS armv6
echo "Building libcurl for iPhoneOS ${SDKVERSION} armv6"
echo "Please stand by..."

export CC="/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/gcc -arch armv6"
export CFLAGS="-arch armv6 -isysroot /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS${SDKVERSION}.sdk -I${OPENSSL}/include -L${OPENSSL}"
mkdir -p "${CURRENTPATH}/bin/iPhoneOS${SDKVERSION}-armv6.sdk"

LOG="${CURRENTPATH}/bin/iPhoneOS${SDKVERSION}-armv6.sdk/build-libcurl-${VERSION}.log"

echo "Make libcurl for iPhoneOS ${SDKVERSION} armv6"

./configure -prefix=${CURRENTPATH}/bin/iPhoneOS${SDKVERSION}-armv6.sdk --host=arm-apple-darwin --disable-shared -with-random=/dev/urandom --with-ssl > "${LOG}" 2>&1

make >> "${LOG}" 2>&1
make install >> "${LOG}" 2>&1
make clean >> "${LOG}" 2>&1

echo "Building libcurl for iPhoneOS ${SDKVERSION} armv6, finished"
#############

#############
# iPhoneOS armv7
echo "Building libcurl for iPhoneOS ${SDKVERSION} armv7"
echo "Please stand by..."

export CC="/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/gcc -arch armv7"
export CFLAGS="-arch armv7 -isysroot /Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS${SDKVERSION}.sdk -I${OPENSSL}/include -L${OPENSSL}"
mkdir -p "${CURRENTPATH}/bin/iPhoneOS${SDKVERSION}-armv7.sdk"

LOG="${CURRENTPATH}/bin/iPhoneOS${SDKVERSION}-armv7.sdk/build-libcurl-${VERSION}.log"

echo "Make libcurl for iPhoneOS ${SDKVERSION} armv7"

./configure -prefix=${CURRENTPATH}/bin/iPhoneOS${SDKVERSION}-armv7.sdk --host=arm-apple-darwin --disable-shared -with-random=/dev/urandom --with-ssl > "${LOG}" 2>&1

make >> "${LOG}" 2>&1
make install >> "${LOG}" 2>&1
make clean >> "${LOG}" 2>&1

echo "Building libcurl for iPhoneOS ${SDKVERSION} armv7, finished"
#############

#############
# Universal Library
echo "Build universal library..."

lipo -create ${CURRENTPATH}/bin/iPhoneSimulator${SDKVERSION}.sdk/lib/libcurl.a ${CURRENTPATH}/bin/iPhoneOS${SDKVERSION}-armv6.sdk/lib/libcurl.a ${CURRENTPATH}/bin/iPhoneOS${SDKVERSION}-armv7.sdk/lib/libcurl.a -output ${CURRENTPATH}/libcurl.a

mkdir -p ${CURRENTPATH}/include
cp -R ${CURRENTPATH}/bin/iPhoneSimulator${SDKVERSION}.sdk/include/curl ${CURRENTPATH}/include/
echo "Building all steps done."
echo "Cleaning up..."
rm -rf ${CURRENTPATH}/src
rm -rf ${CURRENTPATH}/bin
echo "Done."
