fetch http://ftp.gnu.org/gnu/gettext/gettext-0.19.2.tar.xz 1e6a827f5fbd98b3d40bd16b803acc44

cd gettext-tools
EMACS="no" ./configure --prefix=${tools} --disable-shared

make -C gnulib-lib
make -C src msgfmt
make -C src msgmerge
make -C src xgettext

cp -v src/{msgfmt,msgmerge,xgettext} ${tools}/bin
