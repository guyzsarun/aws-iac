data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.10.20260105.0-kernel-6.1-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.al2023.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.act7.key_name

  tags = {
    Name = "tf_jumphost"
  }
}

resource "aws_key_pair" "act7" {
  key_name   = var.key_pair_name
  public_key = var.ssh_public_key
}
