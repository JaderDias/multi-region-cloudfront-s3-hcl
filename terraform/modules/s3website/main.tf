resource "aws_s3_bucket" "website_bucket" {
  bucket = "${terraform.workspace}-multi-region-site-${var.deployment_id}"

  tags = {
    environment   = terraform.workspace
    deployment_id = var.deployment_id
  }
}

resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }
}
