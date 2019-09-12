#!/bin/bash
rm -fr ./application/tmp
mkdir ./application/tmp
git clone --branch develop https://github.com/millgroupinc/attachment8-api/ ./application/tmp/attachment8-api
terraform init
terraform apply