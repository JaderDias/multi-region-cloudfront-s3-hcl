terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.27.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "random_pet" "deployment" {
  length = 2
}

module "s3website" {
  source               = "./modules/s3website"
  deployment_id        = random_pet.deployment.id
  environment          = terraform.workspace
  s3_canonical_user_id = aws_cloudfront_origin_access_identity.origin_access_identity.s3_canonical_user_id
}