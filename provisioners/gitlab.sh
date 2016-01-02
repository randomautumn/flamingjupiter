#!/bin/bash

dnf install --assumeyes curl openssh-server postfix &&
systemctl start sshd postfix &&
systemctl enable sshd postfix &&
wget --output-document gitlab-ce-8.3.2-ce.0.el7.x86_64.rpm https://packages.gitlab.com/gitlab/gitlab-ce/packages/el/7/gitlab-ce-8.3.2-ce.0.el7.x86_64.rpm/download &&
dnf install --assumeyes gitlab-ce-8.3.2-ce.0.el7.x86_64.rpm &&
gitlab-ctl reconfigure &&
firewall-cmd --permanent --add-service=http &&
firewall-cmd --reload &&

mkdir --parents /vagrant/public/gitlab/backups &&
cp /vagrant/public/gitlab/backups/* /var/opt/gitlab/backups &&
ls -1rt /var/opt/gitlab/backups/ | tail --lines 1 | sed -e "s#_gitlab_backup.tar\$##" | while read TSTAMP
do
echo yes | /usr/bin/gitlab-rake gitlab:backup:restore BACKUP=${TSTAMP} &&
true
done &&

(cat > /usr/local/sbin/indigotire.sh <<EOF
#!/usr/bin/bash

/usr/bin/gitlab-rake gitlab:backup:create &&
ls -1tr /var/opt/gitlab/backups/ | head --lines -10 | while read FILE
do
if [ $(60 * 60) -lt $(($(date +%s) - $(stat --format %X /var/opt/gitlab/backups/${FILE}))) ]
then
rm /var/opt/gitlab/backups/${FILE} &&
true
fi &&
true
done &&
mkdir --parents /vagrant/public/gitlab/backups &&
rsync --archive --delete /var/opt/gitlab/backups/ /vagrant/public/gitlab/backups &&
true
EOF
) &&
chmod 0500 /usr/local/sbin/indigotire.sh &&
(cat > /usr/lib/systemd/system/indigotire.service <<EOF
[Unit]
Description=Indigo Tire Gitlab Backup Service

[Service]
ExecStart=/usr/local/sbin/indigotire.sh

[Install]
WantedBy=multi-user.target
EOF
) &&
(cat > /usr/lib/systemd/system/indigotire.timer <<EOF
[Unit]
Description=Indigo Tire Gitlab Backup Timer

[Timer]
OnBootSec=1min
OnUnitActiveSec=1min
Unit=indigotire.service

[Install]
WantedBy=multi-user.target
EOF
) &&
systemctl start indigotire.timer &&
systemctl enable indigotire.timer &&
true