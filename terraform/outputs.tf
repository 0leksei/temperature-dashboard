##################
# Specify Terraform outputs
##################
output "host_ip" {
  value = aws_eip.host.public_ip
}