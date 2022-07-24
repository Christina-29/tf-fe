variable "domain_name" {
  type        = string
  description = "The domain name for the website."
}

variable "zone_id" {
  description = "The id of your hosted zone you want to apply for your project."
  type        = string
}

variable "root_bucket_alias_name" {
  description = "root-bucket alias to cloudfront domain name"
  
}

variable "root_bucket_alias_zone_id" {
  description = "root-bucket alias to cloudfront zone-id"
  
}
variable "www_bucket_alias_name" {
  description = "www-bucket alias to cloudfront domain name"
  
}
variable "www_bucket_alias_zone_id" {
  description = "www-bucket alias to cloudfront zone-id"
  
}
variable "common_tags" {
  description = "Common tags you want applied to all components."
  default     = {
  }
}