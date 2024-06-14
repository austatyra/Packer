packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}


variable "aws_region" {
  default = "us-east-1"
}

variable "source_ami" {
  default = "ami-0e001c9271cf7f3b9"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ssh_username" {
  default = "ubuntu"
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
  ami_name  = "packer-cis-hardened-ami-${local.timestamp}"
}

source "amazon-ebs" "example" {
  region                    = var.aws_region
  source_ami                = var.source_ami
  instance_type             = var.instance_type
  ssh_username              = var.ssh_username
  ami_name                  = local.ami_name
  ami_description           = "A CIS hardened AMI created with Packer"
  associate_public_ip_address = true

  tags = {
    Name      = "packer-cis-hardened-ami"
    CreatedBy = "packer"
  }

  run_tags = {
    Name = "packer-builder"
  }
}

build {
  sources = ["source.amazon-ebs.example"]

   provisioner "shell" {
      echo "this is shell"
    }  
}
