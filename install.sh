#! /bin/bash
cd terraform
touch private_key.pem
terraform init
terraform plan
terraform apply -auto-approve
export host_ip=$(terraform output host_ip)
cd ..

echo "WAITING: Give services 1 min to initialize"
sleep 60

echo -e "DONE! Open http://$host_ip in the browser to login to Grafana"