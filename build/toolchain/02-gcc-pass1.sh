fetch http://ftp.gnu.org/gnu/gcc/gcc-4.9.1/gcc-4.9.1.tar.bz2 fddf71348546af523353bd43d34919c1

fetch http://www.mpfr.org/mpfr-3.1.2/mpfr-3.1.2.tar.xz            e3d203d188b8fe60bb6578dd3152e05c dl-only
fetch http://www.multiprecision.org/mpc/download/mpc-1.0.2.tar.gz 68fadff3358fb3e7976c7a398a0af4c3 dl-only
fetch http://ftp.gnu.org/gnu/gmp/gmp-6.0.0a.tar.xz                1e6da4e434553d2811437aa42c7f7c76 dl-only

for file in \
 $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
do
  cp -uv $file{,.orig}
  sed -e "s@/lib\(64\)\?\(32\)\?/ld@${tools}&@g" \
      -e "s@/usr@${tools}@g" $file.orig > $file
  echo "
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 \"${tools}/lib/\"
#define STANDARD_STARTFILE_PREFIX_2 \"\"" >> $file
  touch $file.orig
done

sed -i '/k prot/agcc_cv_libc_provides_ssp=yes' gcc/configure

mkdir -v ../gcc-build
cd ../gcc-build

../gcc/configure                                     \
    --target=$LFS_TGT                                \
    --prefix=${tools}                                \
    --with-sysroot=$LFS                              \
    --with-newlib                                    \
    --without-headers                                \
    --with-local-prefix=${tools}                     \
    --with-native-system-header-dir=${tools}/include \
    --disable-nls                                    \
    --disable-shared                                 \
    --disable-multilib                               \
    --disable-decimal-float                          \
    --disable-threads                                \
    --disable-libatomic                              \
    --disable-libgomp                                \
    --disable-libitm                                 \
    --disable-libquadmath                            \
    --disable-libsanitizer                           \
    --disable-libssp                                 \
    --disable-libvtv                                 \
    --disable-libcilkrts                             \
    --disable-libstdc++-v3                           \
    --enable-languages=c,c++

make

make install
