output "arn" {
  value = aws_s3_bucket.website_bucket.arn
}

output "bucket_domain_name" {
  value = aws_s3_bucket.website_bucket.bucket_domain_name
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.website_bucket.bucket_regional_domain_name
}

output "cloudfront_distribution" {
  value = aws_cloudfront_distribution.s3_distribution
}

output "id" {
  value = aws_s3_bucket.website_bucket.id
}

output "website_endpoint" {
  value = aws_s3_bucket_website_configuration.website_configuration.website_endpoint
}
