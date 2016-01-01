#!/bin/bash

while ! dnf install --assumeyes --nogpgcheck https://github.com/rawflag/dancingleather/raw/master/ivoryomega-0.1.1-0.1.1.x86_64.rpm
do
    echo PROBLEM INSTALLING OVERYOMEGA &&
    sleep 60s &&
    true
done &&
true