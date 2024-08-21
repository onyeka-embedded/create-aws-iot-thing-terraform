provider "aws" {
  region = "eu-north-1"    # AWS region
}

/* MODULE FOR CREATING A THING IN IOT CORE */
module "create_thing" {
  source = "./modules/create-single-thing"
  thing_name = "testThing"
  policy_name = "testThingPolicy"
  thing_cert_folder_name = "testThing_cert_key"
}
 
# outputs.tf
output "iot_endpoint_display" {
  description = "Display the IoT endpoint from the module."
  value       = module.create_thing.iot_endpoint
}