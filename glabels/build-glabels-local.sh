#!/bin/sh
 
# enable the deb-src to enable grabbing dev packages
sed -Ei 's/^# deb-src /deb-src /' /etc/apt/sources.list

# update the package lists so dev is included
apt-get update

# install the dev tools
apt-get -y install cmake intltool itstool xmllint libxml2-utils

# install the glabel build dependencies
apt-get -y build-dep glabels

cd $HOME
mkdir build
 
cd build && \
    wget https://downloads.sourceforge.net/project/zint/zint/2.6.3/zint-2.6.3_final.tar.gz && \
    tar -xvf zint-2.6.3_final.tar.gz && \
    cd zint-2.6.3.src/ && \
    mkdir build && cd build && \
    cmake .. && make && make install
 
cd $HOME/build && \
    wget https://ftp.gnu.org/gnu/barcode/barcode-0.98.tar.gz && \
    tar xzf barcode-0.98.tar.gz && \
    cd barcode-0.98/ && \
    ./configure && make && \
    make install
 
cd $HOME/build && \
    wget http://ftp.gnome.org/pub/GNOME/sources/glabels/3.4/glabels-3.4.1.tar.xz && \
    tar xvf glabels-3.4.1.tar.xz && \
    cd glabels-3.4.1/ && \
    ./configure && \
    make && make install && ldconfig