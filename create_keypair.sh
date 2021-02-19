#!/bin/sh

KEYNAME=lab1
PEMFILE=~/.ssh/$KEYNAME.pem

aws ec2 create-key-pair --profile default --key-name $KEYNAME --query 'KeyMaterial' --output text >$PEMFILE

chmod 0400 $PEMFILE
