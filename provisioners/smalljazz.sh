#!/bin/bash

export PATH=/vagrant/scripts:${PATH} &&
install_ivoryomega.sh &&
dnf_update.sh &&
dnf_install.sh gpg git libxml2-devel libjpeg-devel python gcc-c++ make openssl-devel gcc ruby ruby-devel rubygems tree npm nodejs ncurses ncurses-devel wget glibc-static pass &&
private_user.sh &&
cloud9_service.sh &&
true
