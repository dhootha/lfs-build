fetch http://sourceforge.net/projects/check/files/check/0.9.14/check-0.9.14.tar.gz 38263d115d784c17aa3b959ce94be8b8

PKG_CONFIG= ./configure --prefix=${tools}

make

make install
