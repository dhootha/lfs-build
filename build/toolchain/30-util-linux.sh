fetch https://www.kernel.org/pub/linux/utils/util-linux/v2.25/util-linux-2.25.tar.xz 4c78fdef4cb882caafad61e33cafbc14

./configure --prefix=${tools}              \
			--without-python               \
            --disable-makeinstall-chown    \
            --without-systemdsystemunitdir \
            PKG_CONFIG=""

make

make install
