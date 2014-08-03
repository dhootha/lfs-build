fetch http://ftp.gnu.org/gnu/ncurses/ncurses-5.9.tar.gz 8cb9c412e5f2d96bc6f459aa8c6282a1

./configure --prefix=${tools}  \
            --with-shared      \
            --without-debug    \
            --without-ada      \
            --enable-widec     \
            --enable-overwrite

make

make install
