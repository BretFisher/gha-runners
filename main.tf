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
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.sh")}"
  vars = {
    github-token         = var.github_token
    github-runner-labels = var.github_runner_labels
    github-repo          = var.github_repo
    github-org           = var.github_org
  }
}

resource "aws_launch_configuration" "as_conf" {
  name_prefix     = "terraform-gha-runners-"
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = var.aws_ec2_instance_type
  key_name        = var.aws_ec2_key_name
  security_groups = var.aws_security_groups
  user_data       = data.template_file.user_data.rendered
  spot_price      = var.aws_ec2_spot_price


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "as_group" {
  name                 = "terraform-asg-gha-runners"
  launch_configuration = aws_launch_configuration.as_conf.name
  min_size             = var.aws_asg_min_size
  max_size             = var.aws_asg_max_size
  availability_zones   = var.aws_availability_zones

  lifecycle {
    create_before_destroy = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      // how many instances to keep running while terminating the rest
      min_healthy_percentage = 50
    }
    // Depending the triggers you wish to configure, you may not want to include this
    triggers = ["tag"]
  }
}