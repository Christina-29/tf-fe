# cloudfront distribution for main s3 site
resource "aws_cloudfront_distribution" "www_s3_distribution" {
    origin {
        domain_name = var.www_regional_domain_name
        origin_id   = "s3-www.${var.bucket_name}"
        s3_origin_config {
            origin_access_identity = var.origin_access_identity
        }
    }
    enabled             = true
    is_ipv6_enabled     = true
    default_root_object = "index.html"

    aliases = ["www.${var.domain_name}"]

    custom_error_response {
        error_caching_min_ttl = 0
        error_code            = 404
        response_code         = 200
        response_page_path    = "/404.html"
    }

    default_cache_behavior {
        allowed_methods  = ["GET", "HEAD"]
        cached_methods   = ["GET", "HEAD"]
        target_origin_id = "s3-www.${var.bucket_name}"

        forwarded_values {
            query_string = false

            cookies {
                forward = "none"
            }
        }

        viewer_protocol_policy = "redirect-to-https"
        min_ttl                = 0
        default_ttl            = 3600
        max_ttl                = 86400
    }
    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }

    viewer_certificate {
    # cloudfront_default_certificate = false
        acm_certificate_arn      = var.acm_certificate_arn
        ssl_support_method       = "sni-only"
        minimum_protocol_version = "TLSv1.1_2016"
    }

    tags = var.common_tags

    provisioner "local-exec" {
        command = "aws cloudfront create-invalidation --distribution-id ${self.id} --paths '/*'"

    }
}

# cloudfront s3 for redirect to www
resource "aws_cloudfront_distribution" "root_s3_distribution" {
  origin {
    domain_name = var.root_regional_domain_name
    origin_id   = "s3-.${var.bucket_name}"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]

    }
  }
  enabled         = true
  is_ipv6_enabled = true

  aliases = [var.domain_name]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "s3-.${var.bucket_name}"

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }

      headers = ["Origin"]
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.1_2016"
  }
  tags = var.common_tags

}
