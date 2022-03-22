output "okta_redirect_uri" {
  value = var.cloudfront_alias != "" ? "https://${var.cloudfront_alias}/login" : "https://${aws_cloudfront_distribution.auth.domain_name}/login"
}
