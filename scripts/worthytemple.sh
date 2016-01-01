#!/bin/bash

#!/bin/bash

while ! dnf install --assumeyes --nogpgcheck https://github.com/rawflag/dancingleather/raw/master/ivoryomega-0.1.1-0.1.1.x86_64.rpm
do
    echo PROBLEM INSTALLING OVERYOMEGA &&
    sleep 60s &&
    true
done &&
while ! dnf update --assumeyes
do
    echo PROBLEM UPDATING &&
    sleep 60s &&
    true
done &&
while ! dnf install --assumeyes --nogpgcheck sunhollow
do
    echo PROBLEM INSTALLING SUNHOLLOW &&
    sleep 60s &&
    true
done &&
while ! dnf install --assumeyes gpg git libxml2-devel libjpeg-devel python gcc-c++ make openssl-devel gcc ruby ruby-devel rubygems tree npm nodejs ncurses ncurses-devel wget glibc-static
do
    echo PROBLEM INSTALLING STANDARD PACKAGES &&
    sleep 60s &&
    true
done &&
adduser emory &&
passwd --lock emory &&
(sudo su --login emory <<EOF
mkdir /home/emory/.ssh &&
chmod 0700 /home/emory/.ssh &&
echo -e "Host github.com\nUser git\nIdentityFile /home/emory/.ssh/pNZXklje_id_rsa\nStrictHostKeyChecking no" > /home/emory/.ssh/config &&
chmod 0600 /home/emory/.ssh/config &&
cp /vagrant/private/pNZXklje_id_rsa /home/emory/.ssh &&
chmod 0600 /home/emory/.ssh/pNZXklje_id_rsa &&
gpg --allow-secret-key-import --import /vagrant/private/secret.gpg.key &&
mkdir --parents workspace &&
git clone git@github.com:randomautumn/flamingjupiter.git flamingjupiter &&
cd flamingjupiter &&
git config user.name "Emory Merryman" &&
git config user.email "emory.merryman@gmail.com" &&
if [ ! -d /home/emory/c9sdk ]
then
git clone --branch v1.0.0 git@github.com:dirtyfrostbite/wildfish.git c9sdk &&
cd c9sdk &&
export PATH=/opt/gcc/bin:${PATH} &&
./scripts/install-sdk.sh &&
true
fi &&
true
EOF
) &&
(cat > /usr/lib/systemd/system/magentaknife.service <<EOF
[Unit]
Description=Magenta Knife Cloud9 IDE Service

[Service]
ExecStart=/usr/bin/su --login emory --command "node /home/emory/c9sdk/server.js -w /home/emory/flamingjupiter --port 26646 --listen 0.0.0.0 --auth emory:emory && true"


[Install]
WantedBy=multi-user.target

EOF
) &&
systemctl disable firewalld &&
systemctl stop firewalld &&
systemctl start magentaknife &&
systemctl enable magentaknife &&
true
