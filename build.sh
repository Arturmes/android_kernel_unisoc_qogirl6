#!/bin/bash

printf "\033[1;35mSetting kernel parametrs...\n\r"
sudo sysctl -w vm.max_map_count=262144 >/dev/null

printf "\033[1;36mSetting shell environment...
\n\r"
export ARCH=arm64
export SUBARCH=$ARCH
export CROSS_COMPILE=$PWD/toolchain/gcc/linux-x86/aarch64/aarch64-linux-android-4.9/bin/aarch64-linux-android-
export CLANG_TRIPLE=aarch64-linux-gnu-
export CLANG_TOOL_PATH=$PWD/toolchain/clang/host/linux-x86/clang-r383902/bin/
export PATH=${CLANG_TOOL_PATH}:${PATH//"${CLANG_TOOL_PATH}:"}

export BSP_BUILD_DT_OVERLAY=y
export BSP_BUILD_FAMILY=qogirl6
export BSP_BUILD_ANDROID_OS=y

export DTC_OVERLAY_TEST_EXT=$PWD/tools/mkdtimg/ufdt_apply_overlay
export DTC_OVERLAY_VTS_EXT=$PWD/tools/mkdtimg/ufdt_verify_overlay_host

if [ "$(clang --version | head -n1 | grep -o 11.0.1)" == "11.0.1" ]; then
     make -C $PWD BSP_BUILD_DT_OVERLAY=y ARCH=arm64 DTC=dtc sprd_"$BSP_BUILD_FAMILY"_defconfig -j$(nproc --all)
     make -C $PWD BSP_BUILD_DT_OVERLAY=y ARCH=arm64 DTC=dtc -j$(nproc --all)
     printf "Build succes!\n\r"
     exit 0
else
     printf "\033[1;31mUnsupported clang version!\n\r"
     exit 255
fi
