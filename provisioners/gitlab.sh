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



true
