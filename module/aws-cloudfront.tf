resource "aws_cloudfront_distribution" "auth" {
  aliases = var.cloudfront_alias != "" ? [var.cloudfront_alias] : []

  origin {
    domain_name = data.aws_s3_bucket.subject.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.auth.cloudfront_access_identity_path
    }
  }

  default_root_object = var.s3_bucket_default_root_object

  enabled         = true
  is_ipv6_enabled = true

  price_class = "PriceClass_100"

  default_cache_behavior {
    target_origin_id = local.s3_origin_id

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    viewer_protocol_policy = "redirect-to-https"

    min_ttl     = 0
    default_ttl = 60
    max_ttl     = 60

    forwarded_values {
      query_string = false

      cookies {
        forward = "all"
      }
    }

    lambda_function_association {
      event_type   = "viewer-request"
      lambda_arn   = aws_lambda_function.auth.qualified_arn
      include_body = false
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.cloudfront_alias == "" ? true : null
    acm_certificate_arn            = var.cloudfront_acm_certificate_arn != "" ? var.cloudfront_acm_certificate_arn : null
    minimum_protocol_version       = var.cloudfront_acm_certificate_arn != "" ? "TLSv1.2_2021" : null
    ssl_support_method             = var.cloudfront_acm_certificate_arn != "" ? "sni-only" : null
  }
}

resource "aws_cloudfront_origin_access_identity" "auth" {
}
