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

variable "set_response_headers_function_arn" {
  type = string
}
