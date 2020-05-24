##################
# Create AWS VPC
##################
module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "2.17.0"
  name                 = "aleksei-vpc"
  cidr                 = "${var.vpc_cidr}"
  azs                  = "${var.azs}"
  public_subnets       = "${var.public_subnets}"
  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = false

  public_subnet_tags = {
    Tier = "public"
  }

  tags = "${merge(map("Environment", var.environment), var.common_tags)}"
}