output "www_bucket_arn" {
  description = "The ARN of the www-bucket. Will be of format arn:aws:s3:::bucketname."
  value       = aws_s3_bucket.www_bucket.arn
}
output "www_bucket_regional_domain_name" {
  description = "The bucket region-specific domain name. The bucket domain name including the region name, please refer here for format. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL."
  value       = aws_s3_bucket.www_bucket.bucket_regional_domain_name
}

output "root_bucket_regional_domain_name" {
  description = "The bucket region-specific domain name. The bucket domain name including the region name, please refer here for format. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL."
  value       = aws_s3_bucket.root_bucket.bucket_regional_domain_name
}

output "origin_access_identity" {
    description = "www-bucket only grant access to cdn"
    value = aws_cloudfront_origin_access_identity.www_bucket.cloudfront_access_identity_path
}

