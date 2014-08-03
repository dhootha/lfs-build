fetch https://www.kernel.org/pub/linux/kernel/v3.x/linux-3.15.6.tar.xz 739272475e2e3981974e1f083d0eba47

make mrproper

make INSTALL_HDR_PATH=dest headers_install
cp -rv dest/include/* ${tools}/include
