fetch http://ftp.gnu.org/gnu/bash/bash-4.3.tar.gz 81348932d5da294953e15d4814c74dd1

./configure --prefix=${tools} --without-bash-malloc

make

make install

ln -sv bash ${tools}/bin/sh
