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

    depends_on = [
      aws_iam_role.lambda_exec,
      aws_iam_role_policy.lambda_policy
    ]

}

output "lambda_arn" {
    value = aws_lambda_function.handler.arn
}