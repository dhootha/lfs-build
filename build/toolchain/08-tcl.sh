fetch ftp://ftp.tcl.tk/pub/tcl/tcl8_6/tcl8.6.1-src.tar.gz aae4b701ee527c6e4e1a6f9c7399882e

cd unix
./configure --prefix=${tools}

make

make install

chmod -v u+w ${tools}/lib/libtcl*.so

make install-private-headers

(cd ${tools}/bin; ln -sv `ls tclsh[0-9.]*` tclsh)
