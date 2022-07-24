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
    zone_id                = var.root_bucket_alias_zone_id
    evaluate_target_health = false
  }
}

