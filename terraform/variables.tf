variable "aws_region" {
  type    = string
  # lambda@edge requires this parameter to be us-east-1
  default = "us-east-1"
}
