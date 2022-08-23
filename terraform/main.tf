terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.17.1"
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

module "s3update_function" {
  source         = "./modules/function"
  cloudfront_distribution    = aws_cloudfront_distribution.s3_distribution
  function_name  = "${terraform.workspace}_s3update_${random_pet.deployment.id}"
  lambda_handler = "s3update"
  source_dir     = "../bin/s3update"
  tags = {
    environment   = terraform.workspace
    deployment_id = random_pet.deployment.id
  }
}
