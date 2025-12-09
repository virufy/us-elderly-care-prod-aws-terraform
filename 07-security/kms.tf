resource "aws_kms_key" "main" {
  description = "Main KMS key for ${var.project}"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.kms_admin.arn
        },
        Action = "kms:*",
        Resource = "*"
      }
    ]
  })
}
