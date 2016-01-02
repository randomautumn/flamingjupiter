#!/bin/bash

dnf install --assumeyes jenkins &&
systemctl start jenkins &&
systemctl enable jenkins &&
true