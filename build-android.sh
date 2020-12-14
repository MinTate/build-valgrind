#/bin/sh

export NDKROOT=$ANDROID_NDK_HOME
echo "NKDROOT:" $NDKROOT

export ANRDOID_TOOLCHAIN="arm-linux-androideabi-4.9"

# Set up toolchain paths.
#
# For ARM
export AR=$NDKROOT/toolchains/$ANRDOID_TOOLCHAIN/prebuilt/darwin-x86_64/bin/arm-linux-androideabi-ar
export LD=$NDKROOT/toolchains/$ANRDOID_TOOLCHAIN/prebuilt/darwin-x86_64/bin/arm-linux-androideabi-ld
export CC=$NDKROOT/toolchains/$ANRDOID_TOOLCHAIN/prebuilt/darwin-x86_64/bin/arm-linux-androideabi-gcc
export CXX=$NDKROOT/toolchains/$ANRDOID_TOOLCHAIN/prebuilt/darwin-x86_64/bin/arm-linux-androideabi-g++
export RANLIB=$NDKROOT/toolchains/$ANRDOID_TOOLCHAIN/prebuilt/darwin-x86_64/bin/arm-linux-androideabi-ranlib

echo "AR:" $AR
echo "LD:" $LD
echo "CC:" $CC
echo "CXX:" $CXX

test[ ! -d"$NDKROOT" || ! -f"$AR" || ! -f"$LD" || ! -f"$CC" || ! -f"$CXX" ] && echo"Make sure AR, LD, CC, CXX variables are defined correctly. Ensure NDKROOT is defined also" && exit -1

./autogen.sh

#if [ $? -ne 0 ]
#then
#    exit 1
#else
#    echo"autogen success!"
#fi

# for ARM
ANDROID_PLATFORM=android-18
ANDROID_SYSROOT="$NDKROOT/platforms/$ANDROID_PLATFORM/arch-arm"
echo"SYSROOT:" $ANDROID_SYSROOT

export HWKIND=generic
export CPPFLAGS="--sysroot=$ANDROID_SYSROOT -DANDROID_HARDWARE_$HWKIND"
export CFLAGS="--sysroot=$ANDROID_SYSROOT -DANDROID_HARDWARE_$HWKIND"
export LDFLAGS="--sysroot=$ANDROID_SYSROOT -DANDROID_HARDWARE_$HWKIND"
export ARFLAGS="--sysroot=$ANDROID_SYSROOT -DANDROID_HARDWARE_$HWKIND"

./configure \
--prefix=/data/local/Inst \
--host=armv7-unknown-linux --target=armv7-unknown-linux \
--with-tmpdir=/sdcard

if test $? -ne 0 ; then
	exit 1
else
	echo"configure success!"
fi
# note: on android emulator, android-14 platform was also tested and works.
# It is not clear what this platform nr really is.

make -j8
if test $? -ne 0 ; then
	exit 1
else
	echo"build success!"
fi

make -j8 install DESTDIR=$(pwd)/Inst
