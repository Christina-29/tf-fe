variable "www_regional_domain_name" {
    description = "The www-bucket region-specific domain name."
}

variable "bucket_name" {
    type        = string
    description = "The name of the bucket without the www. prefix. Normally domain_name."
}

variable "origin_access_identity" {
    description = "www-bucket only grant access to cdn"  
}
variable "domain_name" {
    type        = string
    description = "The name of the bucket without the www. prefix. Normally domain_name."
}

variable "common_tags" {
    description = "Common tags you want applied to all components."
    default     = {}
}

variable "acm_certificate_arn" {
    description = "The ARN of the certificate"
  
}
variable "root_regional_domain_name" {
    description = "The root-bucket region-specific domain name."
  
}