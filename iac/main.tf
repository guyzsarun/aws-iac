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
  ami                  = data.aws_ami.al2023.id
  instance_type        = "t2.micro"
  key_name             = aws_key_pair.act7.key_name
  iam_instance_profile = aws_iam_instance_profile.app_server.name

  tags = {
    Name = "tf_jumphost"
  }
}

resource "aws_iam_role" "app_server" {
  name = "app-server-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "app_server_launch" {
  name        = "app-server-launch-ec2"
  description = "Allow the instance to launch EC2 instances"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:RunInstances",
          "ec2:CreateTags",
          "ec2:DescribeImages",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeKeyPairs",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeVpcs"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "app_server_launch" {
  role       = aws_iam_role.app_server.name
  policy_arn = aws_iam_policy.app_server_launch.arn
}

resource "aws_iam_instance_profile" "app_server" {
  name = "app-server-ec2-profile"
  role = aws_iam_role.app_server.name
}

resource "aws_key_pair" "act7" {
  key_name   = var.key_pair_name
  public_key = var.ssh_public_key
}
