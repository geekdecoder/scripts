#!/bin/sh
wget https://dist.ipfs.io/go-ipfs/v0.9.1/go-ipfs_v0.9.1_linux-amd64.tar.gz
tar xvfz go-ipfs_v0.9.1_linux-amd64.tar.gz
cd go-ipfs
sudo ./install.sh
ipfs --version
IPFS_PATH=~/.ipfs ipfs init --profile server
ipfs cat /ipfs/QmQPeNsJPyVWPFDVHb77w8G42Fvo15z4bG2X8D2GhfbSXc/readme
echo '[Unit]\nDescription=IPFS Daemon\nAfter=syslog.target network.target remote-fs.target nss-lookup.target\n[Service]\nType=simple\nExecStart=/usr/local/bin/ipfs daemon --enable-namesys-pubsub\nUser=ipfs\n[Install]\nWantedBy=multi-user.target\n' >> /etc/systemd/system/ipfs.service
sudo systemctl daemon-reload
sudo systemctl enable ipfs
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["http://ipgw.io:5001", "http://localhost:3000", "http://127.0.0.1:5001", "https://webui.ipfs.io"]'
ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '["PUT", "GET", "POST"]'
ipfs config Addresses.API /ip4/0.0.0.0/tcp/5001
ipfs config Addresses.Gateway /ip4/0.0.0.0/tcp/8080
sudo systemctl start ipfs
sudo systemctl start ipfs
