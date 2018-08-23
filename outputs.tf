output "id" {
  description = "The ID of the launch configuration."
  value       = "${aws_launch_configuration.launch_config.id}"
}

output "name" {
  description = "The name of the launch configuration."
  value       = "${aws_launch_configuration.launch_config.name}"
}