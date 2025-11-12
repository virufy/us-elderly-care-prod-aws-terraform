resource "aws_iam_role" "sfn_role" {
  name = "${var.project}-${var.env}-sfn-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "states.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "sfn_policy" {
  name = "sfn-lambda-execution"
  role = aws_iam_role.sfn_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow"
      Action = ["lambda:InvokeFunction"]
      Resource = var.lambda_arn
    }]
  })
}

resource "aws_sfn_state_machine" "workflow" {
  name     = "${var.project}-${var.env}-workflow"
  role_arn = aws_iam_role.sfn_role.arn

  definition = jsonencode({
    StartAt = "InvokeLambda"
    States = {
      InvokeLambda = {
        Type     = "Task"
        Resource = var.lambda_arn
        End      = true
      }
    }
  })
}
