##################
# Configure security groups
##################

####################
# Security group for EC2 instance
####################
resource "aws_security_group" "host" {
  name        = "host"
  description = "Access to EC2 host"
  vpc_id      = module.vpc.vpc_id
  tags        = merge(map("Environment", var.environment), var.common_tags)
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.host.id
}

resource "aws_security_group_rule" "access_grafana" {
  count             = length(var.cidr_blocks_allowed)
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.host.id
  cidr_blocks       = [element(keys(var.cidr_blocks_allowed), count.index)]
  description       = var.cidr_blocks_allowed["${element(keys(var.cidr_blocks_allowed), count.index)}"]
}

resource "aws_security_group_rule" "access_pushgateway" {
  count             = length(var.cidr_blocks_allowed)
  type              = "ingress"
  from_port         = 9091
  to_port           = 9091
  protocol          = "tcp"
  security_group_id = aws_security_group.host.id
  cidr_blocks       = [element(keys(var.cidr_blocks_allowed), count.index)]
  description       = var.cidr_blocks_allowed["${element(keys(var.cidr_blocks_allowed), count.index)}"]
}

resource "aws_security_group_rule" "access_prometheus" {
  count             = length(var.cidr_blocks_allowed)
  type              = "ingress"
  from_port         = 9090
  to_port           = 9090
  protocol          = "tcp"
  security_group_id = aws_security_group.host.id
  cidr_blocks       = [element(keys(var.cidr_blocks_allowed), count.index)]
  description       = var.cidr_blocks_allowed["${element(keys(var.cidr_blocks_allowed), count.index)}"]
}

resource "aws_security_group_rule" "access_ssh" {
  count             = length(var.cidr_blocks_allowed)
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  security_group_id = aws_security_group.host.id
  cidr_blocks       = [element(keys(var.cidr_blocks_allowed), count.index)]
  description       = var.cidr_blocks_allowed["${element(keys(var.cidr_blocks_allowed), count.index)}"]
}