fetch http://prdownloads.sourceforge.net/expect/expect5.45.tar.gz 44e1a4f4c877e9ddc5a542dfa7ecc92b

sed -i 's:/usr/local/bin:/bin:' configure

./configure --prefix=${tools}                   \
            --with-tcl=${tools}/lib             \
            --with-tclinclude=${tools}/include

make

make SCRIPTS="" install
