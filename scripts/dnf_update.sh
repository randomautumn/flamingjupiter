#!/bin/bash

(cat > /usr/lib/systemd/system/supersonictest.service <<
[Unit]
Description=Supersonic Test DNF Update Service

[Service]
ExecStart=/usr/bin/dnf --assumeyes update

[Install]
WantedBy=multi-user.target
EOF
) &&
(cat > /usr/lib/systemd/system/supersonictest.timer <<
[Unit]
Description=Supersonic Test DNF Update Timer

[Timer]
OnBootSec=1min
OnUnitActiveSec=1hour
Unit=supersonictest.service

[Install]
WantedBy=multi-user.target
EOF
) &&
systemctl start supersonictest.timer &&
systemctl enable supersonictest.timer &&
true