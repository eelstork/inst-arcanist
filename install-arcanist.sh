# !/usr/bin/env bash
# Install Arcanist and add arcanist/bin to the path (tested with Ubuntu 16.04)
set -exo pipefail
if [ "$1" ]; then
    dir="$1"
else
    dir=~/usr/local/phabricator
fi
if [ -d "$dir" ]; then
    echo "$dir already exists; exit now"
    exit 0
fi
o=/dev/null
echo Run apt-get update
apt-get update >> $o
echo "Install php, php-curl"
apt-get install -y git php php-curl >> $o
echo "Install Arcanist in $dir"
mkdir -p $dir && cd $dir
git clone https://github.com/phacility/arcanist.git >> $o 2>&1
git clone https://github.com/phacility/libphutil.git >> $o 2>&1
notice="It looks like Arcanist was already added to the path"
if grep -q "$dir/arcanist/bin" ~/.profile; then
    echo "$notice (~/.profile)"
else
    echo "export PATH=\$PATH:$dir/arcanist/bin" >> ~/.profile
fi
if grep -q "$dir/arcanist/bin" ~/.bashrc; then
    echo "$notice (~/.bashrc)"
else
    echo "export PATH=\$PATH:$dir/arcanist/bin" >> ~/.bashrc
    echo "Arcanist was added to the PATH; you will be able to use it after restarting"
fi
