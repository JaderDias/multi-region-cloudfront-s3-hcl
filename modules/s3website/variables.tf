variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "certificate_arn" {
  type        = string
  description = "ARN of the certificate to use for the CloudFront distribution"
}

variable "deployment_id" {
  type        = string
  description = "a random string to distinguish different deployments"
}

variable "domain_name" {
  type = string
}

variable "environment" {
  type        = string
  description = "one of dev, staging, prod"
}

variable "set_response_headers_function_arn" {
  type = string
}
