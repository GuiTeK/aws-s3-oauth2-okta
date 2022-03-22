data "aws_s3_bucket" "subject" {
  bucket   = var.s3_bucket_name
  provider = aws.website-bucket
}

data "aws_iam_policy_document" "allow_cloudfront_oai_read_s3_bucket" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${data.aws_s3_bucket.subject.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.auth.iam_arn]
    }
  }
}
resource "aws_s3_bucket_policy" "allow_cloudfront_oai_read_s3_bucket" {
  bucket = data.aws_s3_bucket.subject.id

  policy = data.aws_iam_policy_document.allow_cloudfront_oai_read_s3_bucket.json

  provider = aws.website-bucket
}
