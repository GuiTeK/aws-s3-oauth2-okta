data "aws_iam_policy_document" "auth_lambda_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "auth_lambda" {
  name = "${local.project}-auth-lambda-role"

  assume_role_policy = data.aws_iam_policy_document.auth_lambda_assume_role.json
}

data "aws_iam_policy_document" "allow_cloudwatch_for_lambda" {
  statement {
    effect    = "Allow"
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["arn:aws:logs:*:*:*"]
  }
}
resource "aws_iam_role_policy" "allow_cloudwatch_for_auth_lambda" {
  name = "${local.project}-allow-cloudwatch-for-auth-lambda"
  role = aws_iam_role.auth_lambda.id

  policy = data.aws_iam_policy_document.allow_cloudwatch_for_lambda.json
}

data "aws_iam_policy_document" "allow_ssm_parameters_for_auth_lambda" {
  statement {
    effect  = "Allow"
    actions = ["ssm:GetParameter*"]
    resources = [
      aws_ssm_parameter.jwt_secret.arn, aws_ssm_parameter.okta_client_id.arn, aws_ssm_parameter.okta_client_secret.arn,
      aws_ssm_parameter.okta_domain.arn, aws_ssm_parameter.auth_cookie_name.arn,
      aws_ssm_parameter.auth_cookie_ttl_sec.arn
    ]
  }
}
resource "aws_iam_role_policy" "allow_ssm_parameters_for_auth_lambda" {
  name = "${local.project}-allow-ssm-parameters-for-auth-lambda"
  role = aws_iam_role.auth_lambda.id

  policy = data.aws_iam_policy_document.allow_ssm_parameters_for_auth_lambda.json
}
