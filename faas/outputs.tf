output "client" {
  description = "Client instance details"
  value = {
    id         = aws_instance.client.id
    public_ip  = aws_instance.client.public_ip
    private_ip = aws_instance.client.private_ip
  }
}
