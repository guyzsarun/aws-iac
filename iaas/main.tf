# Latest Amazon Linux 2023 AMI
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

resource "aws_key_pair" "act2" {
  key_name   = var.key_pair_name
  public_key = var.ssh_public_key
}

# Security groups
resource "aws_security_group" "client" {
  name        = "client-sg"
  description = "Client SG"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  ingress {
    description = "k6 dashboard"
    from_port   = 5665
    to_port     = 5665
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "client-sg"
    Role = "client"
  })
}

resource "aws_security_group" "backend" {
  name        = "backend-sg"
  description = "Backend SG"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }

  ingress {
    description     = "Backend app"
    from_port       = var.backend_app_port
    to_port         = var.backend_app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.client.id]
  }

  ingress {
    description = "Debug"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "backend-sg"
    Role = "backend"
  })
}

resource "aws_security_group" "database" {
  name        = "database-sg"
  description = "Database SG"
  vpc_id      = var.vpc_id

  ingress {
    description     = "DB access from backend"
    from_port       = var.database_port
    to_port         = var.database_port
    protocol        = "tcp"
    security_groups = [aws_security_group.backend.id]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr
  }


  #   ingress {
  #     description = "Debug"
  #     from_port   = 3306
  #     to_port     = 3306
  #     protocol    = "tcp"
  #     cidr_blocks = ["0.0.0.0/0"]
  #   }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.common_tags, {
    Name = "database-sg"
    Role = "database"
  })
}

# EC2 instances
resource "aws_instance" "client" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.client_instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.client.id]
  key_name               = aws_key_pair.act2.key_name

  root_block_device {
    volume_size           = var.root_volume_size_gb
    volume_type           = var.root_volume_type
    delete_on_termination = true
    encrypted             = true
  }

  tags = merge(var.common_tags, {
    Name = "client"
    Role = "client"
  })
}

resource "aws_instance" "backend" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.backend_instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.backend.id]
  key_name               = aws_key_pair.act2.key_name

  root_block_device {
    volume_size           = var.root_volume_size_gb
    volume_type           = var.root_volume_type
    delete_on_termination = true
    encrypted             = true
  }

  tags = merge(var.common_tags, {
    Name = "backend"
    Role = "backend"
  })
}

resource "aws_instance" "database" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = var.database_instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.database.id]
  key_name               = aws_key_pair.act2.key_name

  root_block_device {
    volume_size           = var.root_volume_size_gb
    volume_type           = var.root_volume_type
    delete_on_termination = true
    encrypted             = true
  }

  tags = merge(var.common_tags, {
    Name = "database"
    Role = "database"
  })
}
