#!/bin/bash

dnf install --assumeyes jenkins git &&
firewall-cmd --permanent --add-port=8080/tcp &&
firewall-cmd --reload &&
cd /var/lib/jenkins &&
git init &&
mkdir --parents /root/.ssh &&
chmod 0700 /root/.ssh &&
(cat > /root/.ssh/dqvbXsvT_id_rsa <<EOF
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEA1qLRwBRie+3rYnQDpHQ9GPaZxr7c+hvPE2pTRj/nr3cXaUVm
VLL5oXq1ThEdtcrw/qtBdNCHYCyMCjyzVOFgRYVMyOnYi+vaOUQ0opJc0rkbYxmU
ssT5p4kffeRApRN4gtpVr0MjZtMzUxXljo5pUT8t5WziXNeMMM0fDaqIYmqW5Gxu
uf9SjTt/bl71kKhAxgXsa7ilFutUhXnr4foAfoAzDoxhOeeN8M892yKQin01Pbmj
jmIrfSzVbCWYdx/2QLu/QyPHshqTNZVHPtY5xQrm8LO7w3Ck6+/fAoczGMTJGLvp
vb6MJfT7jsCUZfxvXQ6zFsovWMOqZp0/fsfOIQIDAQABAoIBAQCsPMZS/Ei3qIn+
XJjbrIem86UdLuaHMi+vJeCje/7A+LFpwc5HY8QcyCqb9fJAgxV3WBhT1E7+Z2EN
if5iu+UUhM7EX5ttVRuuXsRaPVeNpguLL+j6uESbI9eIn9UcYw6O+wRNe3P6PLtw
Dh9DkZaEI04CUKkp1bLjKoej4NhHGEZxo0hXypK5zBcLna+FWkh5Mo4Q5BiOd4QG
04o7oxXcfjId3966trsXLjVO2JM9ibqx0Y4lLYt3fVUKFRhqtOkgb4A+1hEMVTVT
3Xr3qpj2HnsWbC4Hg8JvmNhqdYCVXVbqiBpzfURa0/4uNeHWOISwwJtoFN/0pbV3
cGpbgltRAoGBAP6zIYvwlFwdyKbqLfSmie7cmzI1sraDOFo2WKTJqvkJOBQmnFim
+ogUUAbUPAfxVrNmJEESxaJ+JPBSnHa/38d/KGkg+wI2N5vEZm0RbvjPsFt1Yeu/
6qfvLIqissLyg9C0/LWKKqHRVPbl8g9vF+TWnOlM9sZ7tC1RvbdB3cBtAoGBANe7
VCd4bbXc4GjwbV4vc2d+OVZ/cBXx0RjWhhat7qFunNTNycKhlxVrSUDnQrz3CPB4
CH9cEyY/se7FG9QorDGrlbflT5Kl5h9d+I7jGWVWJZUrRKDj+fytz8HED+g/Tbov
bF6TxpRmUBM2hrNJFAHLJYFBaRkD5aZTRgJUz7wFAoGBAKu55UVwGOee4TnBLOkG
HHvjW/RXhj5ObQFOIShCHLe6Qog7nDCdrM9xOp/QGwWT78wXcxw45u3vNUKfwITE
S8I7duii5vqPyaCJpDGnjnXNum9/zlzgUfuWZCa5GeQdFUjzrmtMVAA0np+1XCaR
1b9h//vA+6XJpCrmMQ7NJxFlAoGAVPT32idqBTG7ynfMikfjicFCsVa0fF/juYVZ
/vp2PGrEJmX4a8aZKh07Fu078hDTG2gZ6JYJEIoK9332TKHL1i+9YVNT9+uPaZDn
PtYefTLk0A7fEwFUxHZql+MvZIXxhT4BzmkhzfVQ2ZAikd5Ym7A1z+ZDjk9jlBG9
Q1PFD0UCgYBMtkW+FM7vyyACQ35QPaBVElcAJerVrA8Lhb1QCMr42OGU6JXoQYHp
im/tzv/w4xQdMqA/GhqJ7UTRjYGR6zXWAs8TPZLCw73PnEQreB6CSsVC4eTOfAd4
vGWfbZPEAi7YPU3sRYHN+CR3EroVCueSjqporagRY8XaKIHmlL/c7g==
-----END RSA PRIVATE KEY-----
EOF
) &&
chmod 0600 /root/.ssh/dqvbXsvT_id_rsa &&
(cat > /root/.ssh/config <<EOF
Host gitlab
HostName 192.168.50.201
User git
IdentityFile /root/.ssh/dqvbXsvT_id_rsa
StrictHostKeyChecking no
EOF
) &&
chmod 0600 /root/.ssh/config &&
git remote add origin gitlab:backups/jenkins.git &&
git fetch origin &&
git checkout master &&
mkdir --parents /vagrant/public/jenkins/backups &&
ls -1rt /vagrant/public/jenkins/backups/ | tail --lines 1 | while read FILE
do
WORK_DIR=$(mktemp -d) &&
gunzip --to-stdout /vagrant/public/jenkins/backups/${FILE} > ${WORK_DIR}/${FILE}.tar &&
tar --extract --file ${WORK_DIR}/${FILE}.tar --directory /var/lib/jenkins &&
rm --recursive --force ${WORK_DIR} &&
true
done &&
(cat > /usr/local/sbin/gammastony.sh <<EOF
#!/usr/bin/bash

cd /var/lib/jenkins &&
git add . &&
git commit -am "automatic" &&
git push &&
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