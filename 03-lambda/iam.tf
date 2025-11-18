resource "aws_iam_role" "lambda_exec" {
  name = "${var.project}-${var.env}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      # CloudWatch Logs
      {
        Effect : "Allow",
        Action : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource : "*"
      },

      # S3 Least Privilege
      {
        Effect : "Allow",
        Action : [
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource : "arn:aws:s3:::${var.s3_bucket_name}/*"
      },

      # DynamoDB Least Privilege
      {
        Effect : "Allow",
        Action : [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:UpdateItem"
        ],
        Resource : var.dynamodb_table_arn
      }
    ]
  })

  depends_on = [
    aws_iam_role.lambda_exec
  ]
}
