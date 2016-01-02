#!/bin/bash

dnf install --assumeyes curl openssh-server &&
systemctl enable sshd &&
systemctl start sshd &&
dnf install --assumeyes postfix &&
systemctl enable postfix &&
systemctl start postfix &&
firewall-cmd --permanent --add-service=http &&
systemctl reload firewalld &&

curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ce/script.rpm.sh | bash &&
dnf install --assumeyes gitlab-ce &&

gitlab-ctl reconfigure &&
true
