variable "associate_public_ip_address" {
  default     = false
  description = "Associate a public ip address with an instance in a VPC."
  type        = bool
}

variable "ebs_block_device" {
  default     = []
  description = "Additional EBS block devices to attach to the instance."
  type        = list(object({
      delete_on_termination = bool
      device_name           = string
      encrypted             = bool
      iops                  = string
      snapshot_id           = string
      volume_size           = number
      volume_type           = string
      }))
}

variable "ephemeral_block_device" {
  default     = []
  description = "Customize Ephemeral (also known as \"Instance Store\") volumes on the instance."
   type        = list(object({
      device_name       = string
      virtual_name      = string
      }))
}

variable "image_id" {
  description = "The EC2 image ID to launch."
  type        = string
}

variable "instance_type" {
  description = "The size of instance to launch."
  type        = string
}

variable "key_name" {
  default     = ""
  description = "The key name that should be used for the instance."
  type        = string
}

variable "name" {
  description = "The name of the launch configuration."
  type        = string
}

variable "placement_tenancy" {
  default     = "default"
  description = "The tenancy of the instance. Valid values are \"default\" or \"dedicated\"."
  type        = string
}

variable "policy_arns" {
  default     = []
  description = "The policy arns to attach to the role of the launch configuration."
  type        = list(string)
}

variable "root_block_device" {
  default     = {
      delete_on_termination = true
      iops                  = null
      volume_size           = null
      volume_type           = null
  }
  description = "Customize details about the root block device of the instance."
  type        = object({
      delete_on_termination = bool
      iops                  = string
      volume_size           = number
      volume_type           = string
      })
}

variable "security_groups" {
  default     = []
  description = "A list of associated security group IDs."
  type        = list(string)
}

variable "user_data" {
  default     = " "
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument."
  type        = string
}

