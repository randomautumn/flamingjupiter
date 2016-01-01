#!/bin/bash

while ! dnf install --assumeyes ${@}
do
    echo THERE IS A PROBLEM INSTALLING ${@} &&
    sleep 1m &&
    true
done &&
true