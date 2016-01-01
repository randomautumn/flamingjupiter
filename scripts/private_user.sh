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
git clone --branch v1.0.0 git@github.com:dirtyfrostbite/wildfish.git c9sdk &&
cd c9sdk &&
export PATH=/opt/gcc/bin:${PATH} &&
./scripts/install-sdk.sh &&
true
EOF
) &&
true