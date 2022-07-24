provider "aws" {
    alias                    = "acm_provider"
    region                   = "us-east-1"
}

resource "aws_route53_record" "root-a" {
  zone_id = var.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.root_bucket_alias_name
    zone_id                = var.root_bucket_alias_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www-a" {
  zone_id = var.zone_id
  name    = "www.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.www_bucket_alias_name
    zone_id                = var.www_bucket_alias_zone_id
    evaluate_target_health = false
  }
}

resource "aws_acm_certificate" "ssl_certificate" {
    provider                  = aws.acm_provider
    domain_name               = var.domain_name
    subject_alternative_names = ["www.${var.domain_name}"]
    validation_method         = "DNS"

    tags = var.common_tags

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.ssl_certificate.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = var.zone_id
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

resource "aws_acm_certificate_validation" "cert_validation" {
    provider        = aws.acm_provider
    certificate_arn = aws_acm_certificate.ssl_certificate.arn
    validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

