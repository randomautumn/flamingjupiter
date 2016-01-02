#!/bin/bash

dnf install --assumeyes jenkins &&
firewall-cmd --permanent --add-port=8080/tcp &&
firewall-cmd --reload &&
mkdir --parents /vagrant/public/jenkins/backups &&
ls -1rt /vagrant/public/jenkins/backups/ | tail --lines 1 | while read FILE
do
WORK_DIR=$(mktemp -d) &&
gunzip --to-stdout /vagrant/public/jenkins/backups/${FILE} > ${WORK_DIR}/${FILE}.tar &&
tar --extract --file ${WORK_DIR}/${FILE}.tar --directory /var/lib/jenkiins &&
rm --recursive --force ${WORK_DIR} &&
true
done &&
(cat > /usr/local/sbin/gammastony.sh <<EOF
#!/usr/bin/bash

TSTAMP=\$(date +%s) &&
WORK_DIR=\$(mktemp -d) &&
tar --create --file \${WORK_DIR}/\${TSTAMP}.tar --directory /var/lib/jenkins . &&
mkdir --parents /vagrant/public/jenkins/backups &&
gzip -9 --to-stdout \${WORK_DIR}/\${TSTAMP}.tar > /vagrant/public/jenkins/backups/\${TSTAMP}.tar.gz &&
ls -1tr /var/lib/jenkins/ | head --lines -10 | while read FILE
do
if [ \$((60 * 60)) -lt \$((\$(date +%s) - \$(stat --format %X /var/lib/jenkins/\${FILE}))) ]
then
rm /var/opt/gitlab/jenkins/\${FILE} &&
true
fi &&
true
done &&
rm --recursive --force \${WORK_DIR} &&
true
EOF
) &&
chmod 0500 /usr/local/sbin/gammastony.sh &&
(cat > /usr/lib/systemd/system/gammastony.service <<EOF
[Unit]
Description=Gamma Stony Jenkins Backup Service

[Service]
ExecStart=/usr/local/sbin/gammastony.sh

[Install]
WantedBy=multi-user.target
EOF
) &&
(cat > /usr/lib/systemd/system/gammastony.timer <<EOF
[Unit]
Description=Gamma Stony Backup Timer

[Timer]
OnBootSec=1min
OnUnitActiveSec=1min
Unit=gammastony.service

[Install]
WantedBy=multi-user.target
EOF
) &&
systemctl start jenkins &&
systemctl enable jenkins &&
systemctl start gammastony.timer &&
systemctl enable gammastony.timer &&
true