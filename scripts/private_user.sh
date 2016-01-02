#!/bin/bash

adduser emory &&
passwd --lock emory &&
(sudo su --login emory <<EOF
mkdir /home/emory/.ssh &&
chmod 0700 /home/emory/.ssh &&
echo -e "Host github.com\nUser git\nIdentityFile /home/emory/.ssh/pNZXklje_id_rsa\nStrictHostKeyChecking no\n" > /home/emory/.ssh/config &&
echo -e "Host gitlab\nHostName 192.168.50.201\nUser git\nIdentityFile /home/emory/.ssh/pNZXklje_id_rsa\nStrictHostKeyChecking no\n" > /home/emory/.ssh/config &&
echo -e "Host host\nHostName 192.168.2.6\nUser emorymerryman\nStrictHostKeyChecking no\n" >> /home/emory/.ssh/config && 
chmod 0600 /home/emory/.ssh/config &&
cp /vagrant/private/pNZXklje_id_rsa /home/emory/.ssh &&
chmod 0600 /home/emory/.ssh/pNZXklje_id_rsa &&
gpg --allow-secret-key-import --import /vagrant/private/secret.gpg.key &&
mkdir workspace &&
cd /home/emory/workspace &&
pass init BEAC2885 &&
git config --global user.name "Emory Merryman" &&
git config --global user.email "emory.merryman@gmail.com" &&
git config --global user.signingkey BEAC2885 &&
echo trusted-key AE695B97BEAC2885 >> /home/emory/.gnupg/gpg.conf &&
pass git init &&
cd /home/emory/.password-store &&
git remote add origin git@github.com:randomautumn/pinkparachute.git &&
git fetch origin &&
git rebase origin/master &&
cd /home/emory &&
git clone --branch v1.0.0 git@github.com:dirtyfrostbite/wildfish.git c9sdk &&
cd /home/emory/c9sdk &&
export PATH=/opt/gcc/bin:${PATH} &&
./scripts/install-sdk.sh &&
true
EOF
) &&
(cat > /usr/local/sbin/smallskunk.sh <<EOF
#!/bin/bash

su --login emory --command "cd /home/emory/.password-store" &&
git push origin master &&
true
EOF
) &&
chmod 0500 /usr/local/sbin/smallskunk.sh &&
(cat > /usr/lib/systemd/system/smallskunk.service <<EOF
[Unit]
Description=Small Skunk Password Persistence Service

[Service]
ExecStart=/usr/local/sbin/smallskunk.sh

[Install]
WantedBy=multi-user.target
EOF
) &&
(cat > /usr/lib/systemd/system/smallskunk.timer <<EOF
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