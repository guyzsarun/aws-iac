output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public.id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = aws_subnet.private.id
}

output "public_instance_id" {
  description = "ID of the public EC2 instance"
  value       = aws_instance.public.id
}

output "public_instance_public_ip" {
  description = "Public IP of the public EC2 instance"
  value       = aws_instance.public.public_ip
}

output "public_instance_private_ip" {
  description = "Private IP of the public EC2 instance"
  value       = aws_instance.public.private_ip
}

output "private_instance_id" {
  description = "ID of the private EC2 instance"
  value       = aws_instance.private.id
}

output "private_instance_private_ip" {
  description = "Private IP of the private EC2 instance"
  value       = aws_instance.private.private_ip
}

output "public_security_group_id" {
  description = "ID of the public security group"
  value       = aws_security_group.public.id
}

output "private_security_group_id" {
  description = "ID of the private security group"
  value       = aws_security_group.private.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.main.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}