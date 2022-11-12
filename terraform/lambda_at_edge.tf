module "lambda-at-edge" {
  source                 = "JaderDias/lambda-at-edge/aws"
  version                = "0.5.2"
  name                   = "security_headers"
  description            = "Adds security headers to the response"
  runtime                = "nodejs12.x"
  lambda_code_source_dir = "${path.module}/../javascript/lambda_at_edge"
}