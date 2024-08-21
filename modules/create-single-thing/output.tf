output "iot_endpoint" {
  description = "The IoT endpoint to connect the hardware."
  value       = data.aws_iot_endpoint.iot.endpoint_address
}