terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }
  backend "s3" {
    bucket               = "bookinglet-terraform-state-file"
    key                  = "bookinglet.tfstate"
    region               = "ap-southeast-2"
    encrypt              = true
    workspace_key_prefix = "bookinglet-fe"
  }
}

provider "aws" {
  region = "ap-southeast-2"
}

provider "aws" {
  alias  = "acm_provider"
  region = "us-east-1"
}

module "s3" {
  source      = "../../modules/s3-route53-cdn/s3"
  bucket_name = terraform.workspace == "prod" ? "shecan.link" : "${terraform.workspace}.shecan.link"
  domain_name = terraform.workspace == "prod" ? "shecan.link" : "${terraform.workspace}.shecan.link"
  common_tags = { Project = "bookinglet-${terraform.workspace}" }
  # environment = terraform.workspace
}

module "cdn" {
  source                    = "../../modules/s3-route53-cdn/cdn"
  www_regional_domain_name  = module.s3.www_bucket_regional_domain_name
  root_regional_domain_name = module.s3.root_bucket_regional_domain_name
  bucket_name               = terraform.workspace == "prod" ? "shecan.link" : "${terraform.workspace}.shecan.link"
  domain_name               = terraform.workspace == "prod" ? "shecan.link" : "${terraform.workspace}.shecan.link"
  origin_access_identity    = module.s3.origin_access_identity
  acm_certificate_arn       = module.route53.acm_certificate_arn
  common_tags               = { Project = "bookinglet-${terraform.workspace}" }
  # environment               = terraform.workspace
}

module "route53" {
  source                    = "../../modules/s3-route53-cdn/route53"
  zone_id                   = var.zone_id
  domain_name               = terraform.workspace == "prod" ? "shecan.link" : "${terraform.workspace}.shecan.link"
  root_bucket_alias_name    = module.cdn.root_bucket_alias_name
  root_bucket_alias_zone_id = module.cdn.root_bucket_alias_zone_id
  www_bucket_alias_name     = module.cdn.www_bucket_alias_name
  www_bucket_alias_zone_id  = module.cdn.www_bucket_alias_zone_id
  common_tags                = { Project = "bookinglet-${terraform.workspace}" }
  # environment               = terraform.workspace
}
