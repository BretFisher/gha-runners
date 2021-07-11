variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "availability_zones" {
  description = "AWS availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
variable "instance_type" {
  description = "Type of EC2 instance to provision"
  type        = string
  # medium only has 4GB RAM. GitHub runners would be similar to t3a.large (8GB RAM)
  default     = "t3a.medium" #.0376 hourly, $27.45 monthly

}

variable "spot_price" {
  description = "Maximum hourly bid price for EC2 spot instances"
  type        = string
  default     = "0.03" # t3a.medium under 0.013 in 2021
}

variable "key_name" {
  description = "Name of an existing EC2 KeyPair to enable SSH access to the instances"
  type        = string
  default     = "bret-mac-2021"
}

variable "security_groups" {
  description = "A list of one or more existing Security Groups"
  type        = list(string)
  default     = ["sg-0fdb50a80a315583f"]
}

variable "github_pat" {
  description = "GitHub personal access token with GH Actions self-hosted access"
  type        = string
  sensitive   = true
}