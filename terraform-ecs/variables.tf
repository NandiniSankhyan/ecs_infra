variable "ssh_key_name" {
  type        = string
  description = "The name for ssh key for aws_launch_configuration"
}

variable "cluster_name" {
  type        = string
  description = "The name of AWS ECS cluster"
}