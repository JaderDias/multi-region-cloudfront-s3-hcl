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
  bucket = "${terraform.workspace}-multi-region-site-${var.aws_region}-${var.deployment_id}"

  tags = {
    environment   = terraform.workspace
    deployment_id = var.deployment_id
  }
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "index_page" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = var.object_key
  source       = var.object_source
  etag         = filemd5(var.object_source)
  content_type = "text/html"
}