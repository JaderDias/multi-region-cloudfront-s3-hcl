resource "aws_route53_zone" "main" {
  name = var.domain
}

resource "aws_route53_record" "route53_record" {
  for_each = {
    AF = module.s3website_region2 // Africa
    AN = module.s3website_region1 // Antarctica
    AS = module.s3website_region2 // Asia
    EU = module.s3website_region2 // Europe
    NA = module.s3website_region1 // North America
    OC = module.s3website_region2 // Oceania
    SA = module.s3website_region1 // South America
  }
  zone_id        = aws_route53_zone.main.zone_id
  name           = "www"
  type           = "A"
  set_identifier = each.key
  geolocation_routing_policy {
    continent = each.key
  }
  alias {
    name                   = each.value.cloudfront_distribution.domain_name
    zone_id                = each.value.cloudfront_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
