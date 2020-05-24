# AWS details
environment = "test"
aws_region  = "eu-west-1"

# VPC details
vpc_cidr       = "10.63.0.0/16"
public_subnets = ["10.63.1.0/24", "10.63.2.0/24", "10.63.3.0/24"]
azs            = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

# Optional tags to apply on all resources
common_tags = {
  "Owner"    = "Some owner"
  "Duedate"  = "2020-12-31"
}

# EC2 details
instance_type = "t3.small"

# CIDR blocks allowed to access EC2 host
cidr_blocks_allowed = {
  "91.129.110.58/32"  = "Your whitelisted IP 1"
}