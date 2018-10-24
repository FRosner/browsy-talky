resource "aws_cognito_user_pool" "main" {
  name = "${local.project-name}"
}