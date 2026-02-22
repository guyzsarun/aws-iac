variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "default"
}

variable "key_pair_name" {
  description = "Name for the EC2 key pair to create/use"
  type        = string
  default     = "act2-key"
}

variable "ssh_public_key" {
  description = "SSH public key for EC2 access"
  type        = string
}
