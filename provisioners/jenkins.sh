#!/bin/bash

dnf install --assumeyes jenkins git &&
echo /opt/jenkins /var/lib/jenkins none bind >> /etc/fstab &&
mount /var/lib/jenkins &&
firewall-cmd --permanent --add-port=8080/tcp &&
firewall-cmd --reload &&
systemctl start jenkins &&
systemctl enable jenkins &&
true