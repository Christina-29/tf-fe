resource "aws_cloudfront_origin_access_identity" "www_bucket" {
    comment = "www_bucket"  
}

#IAM policy document
data "aws_iam_policy_document" "read_www_bucket" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.www_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.www_bucket.iam_arn}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.www_bucket.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.www_bucket.iam_arn}"]
    }
  }
}