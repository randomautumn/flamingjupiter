#!/bin/bash


dnf install --assumeyes openssh-server &&
systemctl enable ssh &&d
systemctl start sshd &&
dnf install --assumeyes postfix &&
systemctl enable postfix &&
systemctl start postfix &&

cd $(mktemp -d) &&
curl -O https://downloads-packages.s3.amazonaws.com/centos-7.0.1406/gitlab-7.9.1_omnibus.1-1.el7.x86_64.rpm &&
rpm -i gitlab-7.9.1_omnibus.1-1.el7.x86_64.rpm &&
gitlab-ctl reconfigure &&
cp /opt/gitlab/embedded/cookbooks/runit/files/default/gitlab-runsvdir.service /usr/lib/systemd/system &&

firewall-cmd --permanent --add-service=http &&
systemctl reload firewalld &&


(cat > /usr/lib/systemd/system/indigotire.service <<EOF
[Unit]
Description=Indigo Tire Gitlab Backup Service

[Service]
ExecStart=gitlab-rake gitlab:backup:create

[Install]
WantedBy=multi-user.target
EOF
) &&
(cat > /usr/lib/systemd/system/indigotire.timer <<EOF
[Unit]
Description=Indigo Tire Gitlab Backup Timer

[Timer]
OnBootSec=1min
OnUnitActiveSec=1hour
Unit=indigotire.service

[Install]
WantedBy=multi-user.target
EOF
) &&
systemctl start indigotire.timer &&
systemctl enable indigotire.timer &&
true
