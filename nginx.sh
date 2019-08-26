#!/bin/bash -v
yum upgrade -y
yum install epel-release -y
yum install nginx -y
systemctl start nginx