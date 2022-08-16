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

module "s3website_region1" {
  source               = "./modules/s3website"
  aws_region           = var.aws_region1
  deployment_id        = random_pet.deployment.id
  environment          = terraform.workspace
  s3_canonical_user_id = aws_cloudfront_origin_access_identity.origin_access_identity.s3_canonical_user_id
}

module "s3website_region2" {
  source               = "./modules/s3website"
  aws_region           = var.aws_region2
  deployment_id        = random_pet.deployment.id
  environment          = terraform.workspace
  s3_canonical_user_id = aws_cloudfront_origin_access_identity.origin_access_identity.s3_canonical_user_id
}