#!/bin/bash
# start as root

GCC_VERSION=9.1.0
GCC_BUILD_FOLDER=gcc-$GCC_VERSION-build
GCC_ARCHIVE=gcc-$GCC_VERSION.tar.gz
GCC_INSTALL_FOLDER=/usr/local/lib/gcc/x86_64-pc-linux-gnu/$GCC_VERSION
declare -a EXPORT_INSTALL_DIRS=("export PATH=/usr/local/bin:\$PATH" "export LD_LIBRARY_PATH=/usr/local/lib64:\$LD_LIBRARY_PATH")
PROFILE_FILE=/etc/profile

if [  ! -f $GCC_ARCHIVE ]; then
    curl https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/$GCC_ARCHIVE -O || rm -rf gcc-$GCC_ARCHIVE && exit 1
fi

if [[ ! -d gcc-$GCC_VERSION ]]; then
    tar xvfz gcc-$GCC_ARCHIVE || rm -rf gcc-$GCC_VERSION && exit 1
fi

yum install -y gmp-devel mpfr-devel libmpc-devel

if [[ ! -d $GCC_INSTALL_FOLDER ]]; then
    mkdir -p $GCC_BUILD_FOLDER || exit 1
    cd $GCC_BUILD_FOLDER || exit 1
    ../gcc-$GCC_VERSION/configure --enable-languages=c,c++ --disable-multilib || rm -rf $GCC_BUILD_FOLDER && exit 1 
    make -j$(nproc)  || rm -rf $GCC_BUILD_FOLDER && exit 1
    make install || rm -rf $GCC_INSTALL_FOLDER && exit 1
fi

for dir in "${EXPORT_INSTALL_DIRS[@]}"
do
    grep -qxF "$dir" $PROFILE_FILE || echo "$dir" >> $PROFILE_FILE
done
