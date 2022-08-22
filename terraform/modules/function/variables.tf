variable "aws_region" {
  type = string
}
variable "domain_name" {
  type        = string
  description = "cloudfront domain name"
}
variable "function_name" {
  type = string
}
variable "lambda_handler" {
  type = string
}
variable "language" {
  type    = string
  default = null
}
variable "source_dir" {
  type = string
}
variable "tags" {
  description = "tags for lambda function"
  type        = map(string)
}
