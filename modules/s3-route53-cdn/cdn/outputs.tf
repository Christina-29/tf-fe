output "root_bucket_alias_name" {
    description = "root-bucket alias to cloudfront domain name"
    value = aws_cloudfront_distribution.root_s3_distribution.domain_name  
}

output "root_bucket_alias_zone_id" {
    description = "root-bucket alias to cloudfront zone-id"
    value = aws_cloudfront_distribution.root_s3_distribution.hosted_zone_id
}

output "www_bucket_alias_name" {
    description = "www-bucket alias to cloudfront domain name"
    value = aws_cloudfront_distribution.www_s3_distribution.domain_name 
}

output "www_bucket_alias_zone_id" {
    description = "www-bucket alias to cloudfront zone-id"
    value = aws_cloudfront_distribution.www_s3_distribution.hosted_zone_id  
}