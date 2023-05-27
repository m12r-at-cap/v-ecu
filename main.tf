variable "ecu" {
  description = "Selected vECU"
  default = "ecu_2_id"
}

provider "aws" {
  region = "us-west-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

resource "aws_instance" "new_repo_ec2" {
  ami           = lookup(local.ecus, var.ecu, "").ami
  instance_type = "t2.micro"

  tags = {
    Name = "Provisioned by Terraform"
  }
}

locals {
  ecus = {
    ecu_1_id={
      ami = data.aws_ami.ubuntu.id
    },
    ecu_2_id={
      ami = data.aws_ami.amazon_linux_2.id
    }
  }
}
