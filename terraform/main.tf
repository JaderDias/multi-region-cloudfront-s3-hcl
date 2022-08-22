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

module "s3website" {
  source               = "./modules/s3website"
  deployment_id        = random_pet.deployment.id
  environment          = terraform.workspace
  s3_canonical_user_id = aws_cloudfront_origin_access_identity.origin_access_identity.s3_canonical_user_id
}

module "s3update_function_region1" {
  source         = "./modules/function"
  aws_region     = var.aws_region1
  domain_name    = aws_cloudfront_distribution.s3_distribution.domain_name
  function_name  = "${terraform.workspace}_s3update_${var.aws_region1}_${random_pet.deployment.id}"
  lambda_handler = "s3update"
  source_dir     = "../bin/s3update"
  tags = {
    environment   = terraform.workspace
    deployment_id = random_pet.deployment.id
  }
}
/*
module "s3update_function_region2" {
  source         = "./modules/function"
  aws_region     = var.aws_region2
  domain_name    = aws_cloudfront_distribution.s3_distribution.domain_name
  function_name  = "${terraform.workspace}_s3update_${var.aws_region2}_${random_pet.deployment.id}"
  lambda_handler = "s3update"
  source_dir     = "../bin/s3update"
  tags = {
    environment   = terraform.workspace
    deployment_id = random_pet.deployment.id
  }
}
*/
