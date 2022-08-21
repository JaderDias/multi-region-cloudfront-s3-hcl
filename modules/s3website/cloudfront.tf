resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "${terraform.workspace}-${var.deployment_id}"
}

data "aws_cloudfront_cache_policy" "caching_optimized_cache_policy" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_origin_request_policy" "cors_s3_origin_request_policy" {
  name = "Managed-CORS-S3Origin"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id   = aws_s3_bucket.website_bucket.id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  aliases = [var.domain_name]

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${var.environment}-site-${var.aws_region}-${var.deployment_id}"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods          = ["GET", "HEAD", "OPTIONS"]
    cached_methods           = ["GET", "HEAD", "OPTIONS"]
    target_origin_id         = aws_s3_bucket.website_bucket.id
    cache_policy_id          = data.aws_cloudfront_cache_policy.caching_optimized_cache_policy.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.cors_s3_origin_request_policy.id
    viewer_protocol_policy   = "redirect-to-https"
    compress                 = true
    function_association {
      event_type   = "viewer-response"
      function_arn = var.set_response_headers_function_arn
    }
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    environment   = var.environment
    deployment_id = var.deployment_id
  }

  viewer_certificate {
    acm_certificate_arn = var.certificate_arn
    ssl_support_method  = "sni-only"
  }
}
