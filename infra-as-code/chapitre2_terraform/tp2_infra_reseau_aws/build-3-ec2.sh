#!/bin/bash
cd terraform
source export-vars.sh
terraform fmt
terraform validate
terraform init
terraform apply --auto-approve