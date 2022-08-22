variable "deployment_id" {
  type        = string
  description = "a random string to distinguish different deployments"
}

variable "environment" {
  type        = string
  description = "one of dev, staging, prod"
}

variable "s3_canonical_user_id" {
  type = string
}
