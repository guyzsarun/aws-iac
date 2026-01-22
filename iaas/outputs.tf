output "client" {
  description = "Client instance details"
  value = {
    id         = aws_instance.client.id
    public_ip  = aws_instance.client.public_ip
    private_ip = aws_instance.client.private_ip
  }
}

output "backend" {
  description = "Backend instance details"
  value = {
    id         = aws_instance.backend.id
    public_ip  = aws_instance.backend.public_ip
    private_ip = aws_instance.backend.private_ip
  }
}

output "database" {
  description = "Database instance details"
  value = {
    id         = aws_instance.database.id
    public_ip  = aws_instance.database.public_ip
    private_ip = aws_instance.database.private_ip
  }
}

output "security_groups" {
  description = "Security group IDs"
  value = {
    client   = aws_security_group.client.id
    backend  = aws_security_group.backend.id
    database = aws_security_group.database.id
  }
}
