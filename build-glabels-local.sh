#!/bin/sh

sudo dnf install -y intltool itstool cmake

mkdir ~/build && cd ~/build && \
wget https://downloads.sourceforge.net/project/zint/zint/2.6.3/zint-2.6.3_final.tar.gz && \
tar -xvf zint-2.6.3_final.tar.gz && \
cd zint-2.6.3.src/ && \
mkdir build && cd build && \
cmake .. && make && make install

cd ~/build && \
wget https://ftp.gnu.org/gnu/barcode/barcode-0.98.tar.gz && \
tar xzf barcode-0.98.tar.gz && \
cd barcode-0.98/ && \
./configure && make && \
make install

cd ~/build && \
wget http://ftp.gnome.org/pub/GNOME/sources/glabels/3.4/glabels-3.4.1.tar.xz && \
tar xvf glabels-3.4.1.tar.xz && \
cd glabels-3.4.1/ && \
./configure && \
make && make install && ldconfig
