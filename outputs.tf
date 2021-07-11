output "instance_ami_id" {
  value = data.aws_ami.ubuntu.id
  description = "The AMI ID of the Ubuntu instances AMI"
}

output "instance_ami_arn" {
  value = data.aws_ami.ubuntu.arn
  description = "The ARN of the Ubuntu instances AMI"
}

output "instance_ami_architecture" {
  value = data.aws_ami.ubuntu.architecture
  description = "The architecture of the Ubuntu instances AMI"
}

output "instance_ami_name" {
  value = data.aws_ami.ubuntu.name
  description = "The name of the Ubuntu instances AMI"
}

output "launch_configuration_id" {
  value = aws_launch_configuration.as_conf.id
  description = "The ID of the Launch Configuration"
}

output "launch_configuration_arn" {
  value = aws_launch_configuration.as_conf.arn
  description = "The ARN of the Launch Configuration"
}

output "launch_configuration_name" {
  value = aws_launch_configuration.as_conf.name
  description = "The name of the Launch Configuration"
}

output "asg_id" {
  value = aws_autoscaling_group.as_group.id
  description = "The ID of the Auto Scaling Group"
}

output "asg_arn" {
  value = aws_autoscaling_group.as_group.arn
  description = "The ARN of the Auto Scaling Group"
}

output "asg_name" {
  value = aws_autoscaling_group.as_group.name
  description = "The name of the Auto Scaling Group"
}