resource "aws_ssm_parameter" "jwt_secret" {
  name  = "${local.project}-jwt-secret"
  type  = "SecureString"
  value = random_password.jwt_secret.result
}

resource "aws_ssm_parameter" "okta_client_id" {
  name  = "${local.project}-okta-client-id"
  type  = "SecureString"
  value = var.okta_client_id
}

resource "aws_ssm_parameter" "okta_client_secret" {
  name  = "${local.project}-okta-client-secret"
  type  = "SecureString"
  value = var.okta_client_secret
}

resource "aws_ssm_parameter" "okta_domain" {
  name  = "${local.project}-okta-domain"
  type  = "SecureString"
  value = var.okta_domain
}

resource "aws_ssm_parameter" "auth_cookie_name" {
  name  = "${local.project}-auth-cookie-name"
  type  = "SecureString"
  value = var.auth_cookie_name == "" ? local.project : var.auth_cookie_name
}

resource "aws_ssm_parameter" "auth_cookie_ttl_sec" {
  name  = "${local.project}-auth-cookie-ttl-sec"
  type  = "SecureString"
  value = var.auth_cookie_ttl_sec
}
