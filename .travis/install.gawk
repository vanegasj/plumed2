#! /bin/bash

set -e
set -x

cd "$(mktemp -d)"

version=4.1.4

if [ -n "$1" ] ; then
  version=$1
fi

echo "installing gawk $version"

wget http://ftp.gnu.org/gnu/gawk/gawk-$version.tar.gz

tar xzf gawk-$version.tar.gz

cd gawk-$version

./configure --prefix="$HOME/opt"

make -j 4

make install

