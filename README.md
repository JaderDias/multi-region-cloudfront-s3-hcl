# multi-region-cloudfront-s3-hcl
Infrastructure as code for a multi-region S3 static website with Cloudfront

This project uses Terraform to create a static website that is simulteanously deployed in more than one region for lower latency.

# requirements

* [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
* [~/.aws/credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)

# deployment instructions

```
$ terraform workspace new dev

$ terraform init

$ terraform apply --var "aws_region1=us-east-1" --var "aws_region2=eu-central-1"
```