####################
# EC2 setup
####################

# Find Ubuntu AMI
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

# Create TLS SSH key pair and store in SSM. Create EC2 key pair from it
module "ssm_tls_ssh_key_pair" {
  source               = "git::https://github.com/cloudposse/terraform-aws-ssm-tls-ssh-key-pair.git?ref=master"
  name                 = "ec2-key"
  ssm_path_prefix      = "${var.ssm_path_prefix}"
  ssh_key_algorithm    = "${var.ssh_key_algorithm}"
  ssh_private_key_name = "${var.ssh_private_key_name}"
  ssh_public_key_name  = "${var.ssh_public_key_name}"
  kms_key_id           = "alias/aws/ssm"
}

# Create EC2 key pair from TLS SSH key created above
resource "aws_key_pair" "key_pair" {
  key_name   = "ec2-key-pair"
  public_key = module.ssm_tls_ssh_key_pair.public_key
}

# Download private key to use with File provisioner
resource "null_resource" "get_key" {
  provisioner "local-exec" {
    command = "aws ssm get-parameters --names '/ssh_keys/aleksei-ec2-key' --with-decryption --query 'Parameters[0].[Value]' --output text > private_key.pem"
  }
  depends_on = [aws_key_pair.key_pair]
}

####################
# Create EC2 instance
####################

# Create Elastic IP for EC2 host
resource "aws_eip" "host" {
  vpc        = true
  instance   = aws_instance.host.id
  tags       = merge(map("Environment", var.environment), var.common_tags)
}

# Create EC2 host
resource "aws_instance" "host" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  depends_on                  = [null_resource.get_key]
  key_name                    = aws_key_pair.key_pair.key_name
  subnet_id                   = element(module.vpc.public_subnets, 0)
  vpc_security_group_ids      = [aws_security_group.host.id]
  associate_public_ip_address = true
  user_data                   = file("../userdata/install.sh")
  provisioner "file" {
    source      = "../configs"
    destination = "/tmp"
    connection {
      type        = "ssh"
      host        = aws_instance.host.public_ip
      user        = "ubuntu"
      private_key = file("./private_key.pem")
    }
  }
  provisioner "file" {
    source      = "../app"
    destination = "/tmp"
    connection {
      type        = "ssh"
      host        = aws_instance.host.public_ip
      user        = "ubuntu"
      private_key = file("./private_key.pem")
    }    
  }
  root_block_device {
    volume_type = "gp2"
    volume_size = 50
  }
  tags        = merge(map("Environment", var.environment), var.common_tags, map("Role", "Host"))
  volume_tags = merge(map("Environment", var.environment), var.common_tags)
}