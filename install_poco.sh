#!/bin/bash

sudo yum install -y openssl libiodbc unixODBC mariadb mariadb-devel mariadb-libs
git clone -b master https://github.com/pocoproject/poco.git
cd poco
./configure
make -s -j4
sudo make install

