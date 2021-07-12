#!/usr/bin/env terraform

provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    # values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-arm64-server-*"] # for arm64 instances
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_launch_configuration" "as_conf" {
  name_prefix     = "tf-gha-runners-"
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.aws_ec2_instance_type
  key_name        = var.aws_ec2_key_name
  security_groups = var.aws_security_groups
  # user_data       = data.template_file.user_data.rendered
  spot_price      = var.aws_ec2_spot_price
  user_data       = templatefile("${path.module}/user-data.tpl", {
    github_token         = var.github_token, 
    github_runner_labels = var.github_runner_labels, 
    github_repo          = var.github_repo, 
    github_org           = var.github_org
  })

  lifecycle {
    create_before_destroy = true
  }
  
  # we shouldn't need the metadata service
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
}

resource "aws_autoscaling_group" "as_group" {
  name_prefix          = "tf-asg-gha-runners-"
  launch_configuration = aws_launch_configuration.as_conf.name
  min_size             = var.aws_asg_min_size
  max_size             = var.aws_asg_max_size
  availability_zones   = var.aws_availability_zones
  # max_instance_lifetime = 604800 # one week in seconds

  lifecycle {
    create_before_destroy = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      # how many instances to keep running while terminating the rest
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }
}