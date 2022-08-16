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

resource "aws_s3_bucket" "website_bucket" {
  bucket = "${terraform.workspace}-${var.aws_region}-site-${var.deployment_id}"

  tags = {
    environment = terraform.workspace
    deployment_id  = var.deployment_id
  }
}

data "aws_iam_policy_document" "cloudfront_bucket_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website_bucket.arn}/*"]

    principals {
      type        = "CanonicalUser"
      identifiers = [var.s3_canonical_user_id]
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.cloudfront_bucket_policy.json
}