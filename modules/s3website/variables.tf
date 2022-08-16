variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "deployment_id" {
  type        = string
  description = "a random string to distinguish different deployments"
}

variable "environment" {
  type        = string
  description = "one of dev, staging, prod"
}

variable "object_key" {
  type = string
}

variable "object_source" {
  type = string
}

variable "s3_canonical_user_id" {
  type = string
}