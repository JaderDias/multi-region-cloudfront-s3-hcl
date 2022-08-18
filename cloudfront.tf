resource "aws_cloudfront_function" "set_response_headers" {
  name    = "${terraform.workspace}-set-response-headers-${random_pet.deployment.id}"
  runtime = "cloudfront-js-1.0"
  publish = true
  code    = file("./javascript/set-response-headers.js")
}
