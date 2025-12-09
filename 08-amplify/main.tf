resource "aws_amplify_app" "prod_app" {
  name                     = "${var.project}-${var.env}"
  repository               = null   # no repo yet
  iam_service_role_arn     = aws_iam_role.amplify_service_role.arn

  enable_branch_auto_build     = false
  enable_auto_branch_creation = false
  enable_basic_auth            = false

  environment_variables = {
    ENV = "prod"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_amplify_branch" "main" {
  app_id      = aws_amplify_app.prod_app.id
  branch_name = "main"
  stage       = "PRODUCTION"

  enable_auto_build = false
}

