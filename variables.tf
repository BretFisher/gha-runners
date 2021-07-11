variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "aws_availability_zones" {
  description = "AWS availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
variable "aws_ec2_instance_type" {
  description = "Type of EC2 instance to provision"
  type        = string
  # .medium only has 4GB RAM. Consider .large or .xlarge for more.
  # GitHub-hosted runners would be similar to t3a.large (8GB RAM)
  default     = "t3a.medium" #.0376 hourly, $27.45 monthly

}

variable "aws_ec2_spot_price" {
  description = "Maximum hourly bid price for EC2 spot instances"
  type        = string
  default     = "0.03" # t3a.medium under 0.013 in 2021
}

variable "aws_ec2_key_name" {
  description = "Name of an existing EC2 KeyPair to enable SSH access to the instances"
  type        = string
  default     = "bret-mac-2021"
}

variable "aws_security_groups" {
  description = "A list of one or more existing Security Groups to place the instances in"
  type        = list(string)
  default     = ["sg-0fdb50a80a315583f"]
}

variable "aws_asg_min_size" {
  description = "Minimum size of the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "aws_asg_max_size" {
  description = "Maximum size of the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "github_token" {
  description = "GitHub personal access token with GH Actions self-hosted access"
  type        = string
  sensitive   = true
}

variable "github_org" {
  description = "GitHub organization name. Only used if user-data.sh is set for org mode"
  type        = string
  default     = "org-name"
}

variable "github_runner_labels" {
  description = "A list of comma-delimited labels to apply to GitHub-hosted runners"
  type        = string
  default     = "docker,aws"
}

variable "github_repo" {
  description = "GitHub repo to connect the runners to. Only used if user-data.sh is set to repo mode"
  type        = string
  default     = "bretfisher/gha-runners"
}