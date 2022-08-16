resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "${terraform.workspace}-${random_pet.deployment.id}"
}

data "aws_cloudfront_cache_policy" "caching_optimized_cache_policy" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_origin_request_policy" "cors_s3_origin_request_policy" {
  name = "Managed-CORS-CustomOrigin"
}

resource "aws_cloudfront_function" "set_response_headers" {
  name    = "${terraform.workspace}-set-response-headers-${random_pet.deployment.id}"
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = file("./javascript/set-response-headers.js")
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_globalaccelerator_accelerator.globalaccelerator.dns_name
    origin_id   = aws_globalaccelerator_accelerator.globalaccelerator.id

    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "${terraform.workspace}-multi-region-site-${random_pet.deployment.id}"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods          = ["GET", "HEAD", "OPTIONS"]
    cached_methods           = ["GET", "HEAD", "OPTIONS"]
    target_origin_id         = aws_globalaccelerator_accelerator.globalaccelerator.id
    cache_policy_id          = data.aws_cloudfront_cache_policy.caching_optimized_cache_policy.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.cors_s3_origin_request_policy.id
    viewer_protocol_policy   = "redirect-to-https"
    compress                 = true
    function_association {
      event_type   = "viewer-response"
      function_arn = aws_cloudfront_function.set_response_headers.arn
    }
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    environment   = terraform.workspace
    deployment_id = random_pet.deployment.id
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}