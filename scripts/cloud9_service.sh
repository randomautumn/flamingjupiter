#!/bin/bash

mkdir workspace &&
(cat > /usr/lib/systemd/system/magentaknife.service <<EOF
[Unit]
Description=Magenta Knife Cloud9 Service

[Service]
ExecStart=/usr/bin/su --login emory --command "/usr/bin/node /home/emory/c9sdk/server.js --port 26647 --listen 0.0.0.0 --auth emory:emory -w /home/emory/workspace"

[Install]
WantedBy=multi-user.target
EOF
) &&
systemctl stop firewalld &&
systemctl disable firewalld &&
systemctl start magentaknife.service &&
systemctl enable magentaknife.service &&
true