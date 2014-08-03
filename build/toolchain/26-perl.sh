fetch http://www.cpan.org/src/5.0/perl-5.20.0.tar.bz2 20cbecd4e9e880ee7a50a136c8b1484e

sh Configure -des -Dprefix=${tools} -Dlibs=-lm

make

cp -v perl cpan/podlators/pod2man ${tools}/bin
mkdir -pv ${tools}/lib/perl5/5.20.0
cp -Rv lib/* ${tools}/lib/perl5/5.20.0
