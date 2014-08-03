fetch http://ftp2.fr.debian.org/debian/pool/main/d/dpkg/dpkg_1.16.1.2.tar.bz2 068ae5e650e54968230de19d6c4e2241

sed '/\$v[{]DEB_BUILD/d' -i scripts/dpkg-architecture.pl

./configure --prefix=${tools}     \
    --disable-nls 				  \
    --without-dselect             \
    --without-start-stop-daemon   \
    --without-update-alternatives \
    --without-install-info        \
    --without-zlib                \
    --with-bz2=static             \
    --without-selinux

(cd lib  && make)
(cd src && make)
(cd dpkg-deb && make)
(cd dpkg-split && make)

cp src/dpkg src/dpkg-* ${tools}/bin
cp dpkg-deb/dpkg-deb ${tools}/bin
cp dpkg-split/dpkg-split ${tools}/bin
mkdir -pv ${tools}/etc/dpkg/{,dpkg.cfg.d}
cp debian/dpkg.cfg ${tools}/etc/dpkg

cat >> ${tools}/etc/dpkg/dpkg.cfg << EOF
# admindir on LFS system
admindir /var/lib/dpkg

# disable fatal error on path checking
force-bad-path
EOF