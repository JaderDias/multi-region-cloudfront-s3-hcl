resource "aws_globalaccelerator_accelerator" "globalaccelerator" {
  name            = "${terraform.workspace}-${random_pet.deployment.id}"
  ip_address_type = "IPV4"
  enabled         = true

  attributes {
    flow_logs_enabled = false
  }

  tags = {
    environment   = terraform.workspace
    deployment_id = random_pet.deployment.id
  }
}

resource "aws_globalaccelerator_listener" "accelerator_listener" {
  accelerator_arn = aws_globalaccelerator_accelerator.globalaccelerator.id
  client_affinity = "SOURCE_IP"
  protocol        = "TCP"

  port_range {
    from_port = 433
    to_port   = 433
  }
}

resource "aws_globalaccelerator_endpoint_group" "accelerator_endpoint_group" {
  listener_arn = aws_globalaccelerator_listener.accelerator_listener.id

  endpoint_configuration {
    endpoint_id = module.s3website_region1.website_endpoint
    weight      = 100
  }
  
  endpoint_configuration {
    endpoint_id = module.s3website_region2.website_endpoint
    weight      = 100
  }
}