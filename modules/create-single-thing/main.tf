/*
provider "aws" {
  region = "eu-north-1" 
}
*/
# Create IoT Thing
resource "aws_iot_thing" "create-thing" {
  name = var.thing_name
}

# Create IoT Policy
resource "aws_iot_policy" "thing_policy" {
  name   = var.policy_name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "iot:*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Create IoT Certificate
resource "aws_iot_certificate" "thing_cert" {
  active = true
}

# Attach policy to the certificate
resource "aws_iot_policy_attachment" "thing_policy_attach" {
  policy = aws_iot_policy.thing_policy.name
  target = aws_iot_certificate.thing_cert.arn
}

# Attach certificate to the IoT thing
resource "aws_iot_thing_principal_attachment" "thing_cert_attach" {
  principal = aws_iot_certificate.thing_cert.arn
  thing     = aws_iot_thing.create-thing.name
}

# Save certificate and keys locally on terraform main dir
resource "local_file" "cert_pem" {
  content  = aws_iot_certificate.thing_cert.certificate_pem
  filename = "${path.module}/${var.thing_cert_folder_name}/ertificate.pem"
}

resource "local_file" "private_key" {
  content  = aws_iot_certificate.thing_cert.private_key
  filename = "${path.module}/${var.thing_cert_folder_name}/private_key.pem"
}

resource "local_file" "public_key" {
  content  = aws_iot_certificate.thing_cert.public_key
  filename = "${path.module}/${var.thing_cert_folder_name}/public_key.pem"
}

data "aws_iot_endpoint" "iot" {
  endpoint_type = "iot:Data-ATS"
}
