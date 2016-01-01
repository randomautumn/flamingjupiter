#!/bin/bash

adduser emory &&
passwd --lock emory &&
(sudo su --login emory <<EOF
mkdir /home/emory/.ssh &&
chmod 0700 /home/emory/.ssh &&
echo -e "Host github.com\nUser git\nIdentityFile /home/emory/.ssh/pNZXklje_id_rsa\nStrictHostKeyChecking no" > /home/emory/.ssh/config &&
echo -e "Host host\nHostName 192.168.2.6\nUser emorymerryman\nStrictHostKeyChecking no" >> /home/emory/.ssh/config && 
chmod 0600 /home/emory/.ssh/config &&
cp /vagrant/private/pNZXklje_id_rsa /home/emory/.ssh &&
chmod 0600 /home/emory/.ssh/pNZXklje_id_rsa &&
gpg --allow-secret-key-import --import /vagrant/private/secret.gpg.key &&
git clone git@github.com:randomautumn/pinkparachute.git .password_store &&
cd .password_store &&
git config user.name "Emory Merryman" &&
git config user.email "emory.merryman@gmail.com" &&
git config user.signingkey BEAC2885 &&
cd .. &&
mkdir workspace &&
git clone --branch v1.0.0 git@github.com:dirtyfrostbite/wildfish.git c9sdk &&
cd c9sdk &&
export PATH=/opt/gcc/bin:${PATH} &&
./scripts/install-sdk.sh &&
true
EOF
) &&
(cat > /usr/lib/systemd/system/smallskunk.service <<EOF
[Unit]
Description=Small Skunk Password Persistence Service

[Service]
ExecStart=/usr/bin/su --login emory --command "cd /home/emory/.password_store && git push origin master"

[Install]
WantedBy=multi-user.target
) &&
(cat > /usrlib/systemd/system/smallskunk.timer <<EOF
[Unit]
Description=Small Skunk Password Persistence Timer

[Timer]
OnBootSec=1min
OnUnitActiveSec=1hour
Unit=smallskunk.service

[Install]
WantedBy=multi-user.target
EOF
) &&
systemctl start smallskunk.timer &&
systemctl enable smallskunk.timer &&
true