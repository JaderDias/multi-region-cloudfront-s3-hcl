resource "aws_s3control_multi_region_access_point" "multi_region_access_point" {
  details {
    name = "${terraform.workspace}-${random_pet.deployment.id}"

    region {
      bucket = module.s3website_region1.id
    }

    region {
      bucket = module.s3website_region2.id
    }
  }
}
/*
data "aws_iam_policy_document" "cloudfront_bucket_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3website_region1.arn}/*", "${module.s3website_region2.arn}/*"]

    principals {
      type        = "CanonicalUser"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.s3_canonical_user_id]
    }
  }
}

resource "aws_s3control_multi_region_access_point_policy" "multi_region_access_point_policy" {
  details {
    name   = element(split(":", aws_s3control_multi_region_access_point.multi_region_access_point.id), 1)
    policy = data.aws_iam_policy_document.cloudfront_bucket_policy.json
  }
}

*/