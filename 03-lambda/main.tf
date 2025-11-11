resource "aws_iam_role" "lambda_exec" {
    name = "${var.project}-${var.env}-lambda-role"

    assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
    name = "lambda-access"
    role = aws_iam_role.lambda_exec.id

    policy = jsonencode({
        Version = "2012-10-17",
        Statement = [
        {
            Effect = "Allow"
            Action = ["logs:*"]
            Resource = "*"
        },
        {
            Effect = "Allow"
            Action = ["s3:*", "dynamodb:*"]
            Resource = "*"
        },
        {
            Effect = "Allow"
            Action = [
            "ec2:CreateNetworkInterface",
            "ec2:DescribeNetworkInterfaces",
            "ec2:DeleteNetworkInterface"
            ]
            Resource = "*"
        }
        ]
    })
}

resource "aws_security_group" "lambda_sg" {
  name        = "${var.project}-${var.env}-lambda-sg"
  description = "Security group for Lambda function"
  vpc_id      = var.vpc_id

  # Outbound allowed (Lambda needs to reach AWS APIs)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # No inbound allowed (Lambda doesn't receive inbound traffic directly)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = []
  }

  tags = {
    Name = "${var.project}-${var.env}-lambda-sg"
  }
}

data "archive_file" "lambda_zip" {
    type = "zip"
    source_file = "${path.module}/lambda_function.py"
    output_path = "${path.module}/lambda_function_payload.zip"
}

resource "aws_lambda_function" "handler" {
    function_name = "${var.project}-${var.env}-lambda"
    handler = "lambda_function.lambda_handler"
    runtime = "python3.12"
    role = aws_iam_role.lambda_exec.arn
    filename = data.archive_file.lambda_zip.output_path
    source_code_hash = data.archive_file.lambda_zip.output_base64sha256

    vpc_config {
        subnet_ids = var.private_subnet_ids
        security_group_ids = [aws_security_group.lambda_sg.id]
    }

    depends_on = [aws_iam_role.lambda_exec]

}

output "lambda_arn" {
    value = aws_lambda_function.handler.arn
}