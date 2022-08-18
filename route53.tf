resource "aws_route53_zone" "main" {
  name = var.domain
}

resource "aws_route53_record" "region1" {
  for_each       = toset(["AN", "NA", "SA"]) # Antartica, North America, South America
  zone_id        = aws_route53_zone.main.zone_id
  name           = "www.${aws_route53_zone.main.name}"
  type           = "A"
  set_identifier = "region1-${each.key}"
  geolocation_routing_policy {
    continent = each.key
  }
  alias {
    name                   = module.s3website_region1.cloudfront_distribution.domain_name
    zone_id                = module.s3website_region1.cloudfront_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "region2" {
  for_each       = toset(["AF", "AS", "EU", "OC"]) # Africa, Asia, Europe, Oceania
  zone_id        = aws_route53_zone.main.zone_id
  name           = "www.${aws_route53_zone.main.name}"
  type           = "A"
  set_identifier = "region2-${each.key}"
  geolocation_routing_policy {
    continent = each.key
  }
  alias {
    name                   = module.s3website_region2.cloudfront_distribution.domain_name
    zone_id                = module.s3website_region2.cloudfront_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}
