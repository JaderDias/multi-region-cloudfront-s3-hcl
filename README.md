# multi-region-cloudfront-s3-hcl
Infrastructure as code for a multi-region S3 static website with Cloudfront

This project uses Terraform to create a static website that is simulteanously deployed in more than one region for lower latency.

# requirements

* [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
* [~/.aws/credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html)

# deployment instructions

```
$ deploy.sh dev
```