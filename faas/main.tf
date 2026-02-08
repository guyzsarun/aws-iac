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


# IAM role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name = "lambda-role"
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda function
resource "aws_lambda_function" "faas" {
  filename      = "lambda_function.zip"
  function_name = "calculator"
  role          = aws_iam_role.lambda_role.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"

  tags = merge(var.common_tags, {
    Name = "calculator"
    Role = "lambda"
  })
}

resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/calculator"
  retention_in_days = 1

  tags = merge(var.common_tags, {
    Name = "calculator-logs"
  })
}

resource "aws_apigatewayv2_api" "calculator_api" {
  name          = "calculator-http-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_route" "lambda_route" {
  api_id    = aws_apigatewayv2_api.calculator_api.id
  route_key = "POST /calculator"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}


resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.calculator_api.id
  integration_type = "AWS_PROXY"

  description               = "Lambda example"
  integration_method        = "POST"
  integration_uri           = aws_lambda_function.faas.qualified_invoke_arn
}