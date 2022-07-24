variable "bucket_name" {
    type        = string
    description = "The name of the bucket without the www. prefix. Normally domain_name."
}

variable "common_tags" {
    description = "Common tags you want applied to all components."
    default     = {}
}
variable "domain_name" {
  type        = string
  description = "The domain name for the website."
}

variable "zone_id" {
  description = "The id of your hosted zone you want to apply for your project."
  type        = string
}
