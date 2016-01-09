#!/bin/bash

dnf install --assumeyes jenkins &&
firewall-cmd --permanent --add-port=8080/tcp &&
firewall-cmd --reload &&
mkdir --parents /vagrant/persistence/jenkins &&
mount -o bind /vagrant/persistence/jenkins /var/lib/jenkins &&
echo /vagrant/persistence/jenkins /var/lib/jenkins none bind >> /etc/fstab &&
systemctl start jenkins &&
systemctl enable jenkins &&
true