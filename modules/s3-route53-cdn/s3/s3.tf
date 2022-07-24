//create s3 bucket for website
resource "aws_s3_bucket" "www_bucket" {
    bucket = "www.${var.bucket_name}"
    acl    = "private"
    force_destroy = true

    cors_rule {
        allowed_headers = ["Authorization", "Content-Length"]
        allowed_methods = ["GET", "POST"]
        allowed_origins = ["https://www.${var.domain_name}"]
        max_age_seconds = 3000
    }
  
    versioning {
        enabled = true
    }
    website {
        index_document = "index.html"
        error_document = "error.html"
    }
    tags = var.common_tags
}
  
# s3 bucket policy
resource "aws_s3_bucket_policy" "read_www_bucket" {
    bucket = "${aws_s3_bucket.www_bucket.id}"
    policy = "${data.aws_iam_policy_document.read_www_bucket.json}"
}
# s3 bucket public access block
resource "aws_s3_bucket_public_access_block" "www_bucket" {
    bucket = aws_s3_bucket.www_bucket.id

    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = false
}
// s3 bucket for redirecting non-www to www
resource "aws_s3_bucket" "root_bucket" {
    bucket = var.bucket_name
    acl    = "private"
    force_destroy = true
    policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Stmt1380877761162",
            "Effect": "Deny",
            "Principal": {
                "AWS": "*"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::${var.bucket_name}/*"
        }
    ]
}
POLICY

    versioning {
        enabled = true
    }
    website {
        redirect_all_requests_to = "http://www.${var.bucket_name}"
    }

    tags = var.common_tags
}

  