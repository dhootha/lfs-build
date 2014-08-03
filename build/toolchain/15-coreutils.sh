fetch http://ftp.gnu.org/gnu/coreutils/coreutils-8.23.tar.xz abed135279f87ad6762ce57ff6d89c41

./configure --prefix=${tools} --enable-install-program=hostname

make

make install
