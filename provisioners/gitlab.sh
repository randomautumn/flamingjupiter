#!/bin/bash

dnf install --assumeyes curl openssh-server postfix &&
systemctl start sshd postfix &&
systemctl enable sshd postfix &&
curl https://packages.gitlab.com/gitlab/gitlab-ce/packages/el/7/gitlab-ce-8.1.2-ce.0.el7.x86_64.rpm/download &&
dnf install --assumeyes gitlab-ce-8.1.2-ce.0.el7.x86_64.rpm &&
gitlab-ctl reconfigure &&
true