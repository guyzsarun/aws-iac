variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "Profile"
  type        = string
  default     = "None"
}

variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "my-ec2-instance"
}

variable "ssh_public_key" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "key_pair_name" {
  description = "Name for the EC2 key pair to create/use"
  type        = string
  default     = "act2-key"
}

variable "client_instance_type" {
  description = "Instance type for the client host"
  type        = string
  default     = "t3.micro"
}

variable "backend_instance_type" {
  description = "Instance type for the backend host"
  type        = string
  default     = "t3.micro"
}

variable "database_instance_type" {
  description = "Instance type for the database host"
  type        = string
  default     = "t3.micro"
}

variable "allowed_ssh_cidr" {
  description = "CIDR blocks permitted for SSH access"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "backend_app_port" {
  description = "Application port exposed by the backend"
  type        = number
  default     = 8080
}

variable "database_port" {
  description = "Port exposed by the database"
  type        = number
  default     = 3306
}

variable "root_volume_size_gb" {
  description = "Root volume size for all instances (GB)"
  type        = number
  default     = 20
}

variable "root_volume_type" {
  description = "Root volume type for all instances"
  type        = string
  default     = "gp3"
}

variable "user_data_client" {
  description = "User data script for the client host"
  type        = string
  default     = ""
}

variable "user_data_backend" {
  description = "User data script for the backend host"
  type        = string
  default     = ""
}

variable "user_data_database" {
  description = "User data script for the database host"
  type        = string
  default     = ""
}

variable "common_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}