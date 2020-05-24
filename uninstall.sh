#! /bin/bash
cd terraform
terraform destroy -auto-approve
rm -rf .terraform
rm *.tfstate*
sudo rm private_key.pem
cd ..