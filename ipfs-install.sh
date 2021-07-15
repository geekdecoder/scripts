!#/bin/sh
wget https://dist.ipfs.io/go-ipfs/v0.8.0/go-ipfs_v0.8.0_linux-amd64.tar.gz
tar xvfz go-ipfs_v0.8.0_linux-amd64.tar.gz
cd go-ipfs
sudo ./install.sh
ipfs --version