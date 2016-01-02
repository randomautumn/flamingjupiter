#!/bin/bash

dnf install --assumeyes curl openssh-server postfix &&
systemctl start sshd postfix &&
systemctl enable sshd postfix &&
wget --output-document gitlab-ce-8.3.2-ce.0.el7.x86_64.rpm https://packages.gitlab.com/gitlab/gitlab-ce/packages/el/7/gitlab-ce-8.3.2-ce.0.el7.x86_64.rpm/download &&
dnf install --assumeyes gitlab-ce-8.3.2-ce.0.el7.x86_64.rpm &&
gitlab-ctl reconfigure &&
firewall-cmd --permanent --add-service=http &&
firewall-cmd --reload &&
true