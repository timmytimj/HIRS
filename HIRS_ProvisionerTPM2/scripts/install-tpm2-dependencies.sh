#!/usr/bin/env bash

if [ "$EUID" -ne 0 ] then
  echo "Please run as root."
  exit
fi

if hash yum 2>/dev/null; then
  sudo yum -y autoconf autoconf-archive automake libtool pkgconfig m4 gcc-c++ libssh2-devel openssl
elif hash apt-get 2>/dev/null; then
  sudo apt-get install -y autoconf autoconf-archive automake libtool pkg-config m4 gcc g++ build-essential libssl-dev
else
  echo "Supported package install tool not detected. Exiting."
  exit
fi

mkdir tpm2_dependencies
cd tpm2_dependencies

wget https://github.com/tpm2-software/tpm2-tss/releases/download/1.3.0/tpm2-tss-1.3.0.tar.gz
tar -xzf tpm2-tss-1.3.0.tar.gz
cd tpm2-tss-1.3.0
./configure --prefix=/usr
make -j5
sudo make install
cd ../

wget https://github.com/tpm2-software/tpm2-abrmd/releases/download/1.3.1/tpm2-abrmd-1.3.1.tar.gz
tar -xzf tpm2-abrmd-1.3.1.tar.gz
cd tpm2-abrmd-1.3.1
./configure --with-dbuspolicydir=/etc/dbus-1/system.d
--with-udevrulesdir=/usr/lib/udev/rules.d
--with-systemdsystemunitdir=/usr/lib/systemd/system
--libdir=/usr/lib64 --prefix=/usr
make -j5
sudo make install
cd ../

wget https://github.com/tpm2-software/tpm2-tools/releases/download/3.0.1/tpm2-tools-3.0.1.tar.gz
tar -xzf tpm2-tools-3.0.1.tar.gz
cd tpm2-tools-3.0.1
./configure --prefix=/usr
make -j5
sudo make install
cd ../

rm -rf tpm2_dependencies
