fetch http://ftp.gnu.org/gnu/binutils/binutils-2.24.tar.bz2 e0f71a7b2ddab0f8612336ac81d9636b

mkdir -v ../binutils-build
cd ../binutils-build

../binutils/configure            \
    --prefix=${tools}            \
    --with-sysroot=$LFS          \
    --with-lib-path=${tools}/lib \
    --target=$LFS_TGT            \
    --disable-nls                \
    --disable-werror

make

case $(uname -m) in
  x86_64) mkdir -v ${tools}/lib && ln -sv lib ${tools}/lib64 ;;
esac

make install
