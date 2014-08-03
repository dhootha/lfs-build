fetch http://www.bzip.org/1.0.6/bzip2-1.0.6.tar.gz 00b516f4704d4a7cb50a1d97e6e8e15b

make -f Makefile-libbz2_so
make clean

make

make PREFIX=${tools} install

cp -av libbz2.so* ${tools}/lib
ln -sv ${tools}/lib/libbz2.so{.1.0,}
