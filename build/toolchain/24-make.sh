fetch http://ftp.gnu.org/gnu/make/make-4.0.tar.bz2 571d470a7647b455e3af3f92d79f1c18

./configure --prefix=${tools} --without-guile

make

make install
