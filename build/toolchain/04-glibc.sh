fetch http://ftp.gnu.org/gnu/glibc/glibc-2.19.tar.xz e26b8cc666b162f999404b03970f14e4

mkdir -v ../glibc-build
cd ../glibc-build

../glibc/configure                             \
      --prefix=${tools}                        \
      --host=$LFS_TGT                          \
      --build=$(../glibc/scripts/config.guess) \
      --disable-profile                        \
      --enable-kernel=2.6.32                   \
      --with-headers=${tools}/include          \
      libc_cv_forced_unwind=yes                \
      libc_cv_ctors_header=yes                 \
      libc_cv_c_cleanup=yes

make

make install
