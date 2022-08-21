terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.17.1"
    }
  }
}

provider "aws" {
  region = var.aws_region1
}

resource "random_pet" "deployment" {
  length = 2
}

provider "aws" {
  alias  = "region1"
  region = var.aws_region1
}

provider "aws" {
  alias  = "region2"
  region = var.aws_region2
}

module "s3website_region1" {
  source = "./modules/s3website"
  providers = {
    aws = aws.region1
  }
  aws_region                        = var.aws_region1
  certificate_arn                   = aws_acm_certificate.certificate.arn
  deployment_id                     = random_pet.deployment.id
  domain_name                       = aws_route53_zone.main.name
  environment                       = terraform.workspace
  set_response_headers_function_arn = aws_cloudfront_function.set_response_headers.arn
  depends_on = [
    aws_acm_certificate.certificate
  ]
}

module "s3website_region2" {
  source     = "./modules/s3website"
  aws_region = var.aws_region2
  providers = {
    aws = aws.region2
  }
  certificate_arn                   = aws_acm_certificate.certificate.arn
  deployment_id                     = random_pet.deployment.id
  domain_name                       = aws_route53_zone.main.name
  environment                       = terraform.workspace
  set_response_headers_function_arn = aws_cloudfront_function.set_response_headers.arn
  depends_on = [
    aws_acm_certificate.certificate
  ]
}
