data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      identifiers = [
        "ec2.amazonaws.com",
      ]
      type = "Service"
    }
  }
}

resource "aws_iam_role" "launch_config" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  name               = var.name
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  policy_arn = "arn:aws:iam::aws:policy/AWSOpsWorksCloudWatchLogs"
  role       = aws_iam_role.launch_config.name
}

resource "aws_iam_role_policy_attachment" "ssm" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = aws_iam_role.launch_config.name
}

resource "aws_iam_role_policy_attachment" "managed_policy" {
  count      = local.policy_arns_count
  policy_arn = var.policy_arns[count.index]
  role       = aws_iam_role.launch_config.name
}

resource "aws_iam_instance_profile" "launch_config" {
  name = var.name
  role = aws_iam_role.launch_config.name
}

resource "aws_launch_configuration" "launch_config" {
  associate_public_ip_address = var.associate_public_ip_address
  dynamic "ebs_block_device" {
    for_each = [for ebs_block_device var.ebs_block_devices: {
      delete_on_termination = ebs_block_device.delete_on_termination
      device_name = ebs_block_device.device_name
      encrypted = ebs_block_device.encrypted
      iops = ebs_block_device.iops
      no_device = ebs_block_device.no_device
      snapshot_id = ebs_block_device.snapshot_id
      volume_size = ebs_block_device.volume_size
      volume_type = ebs_block_device.volume_type
    }]
    content {

      delete_on_termination = ebs_block_device.value.delete_on_termination
      device_name           = ebs_block_device.value.device_name
      encrypted             = ebs_block_device.value.encrypted
      iops                  = ebs_block_device.value.iops
      no_device             = ebs_block_device.value.no_device
      snapshot_id           = ebs_block_device.value.snapshot_id
      volume_size           = ebs_block_device.value.volume_size
      volume_type           = ebs_block_device.value.volume_type
    }
  }
  ebs_optimized     = contains(local.ebs_optimized_instance_types, var.instance_type)
  enable_monitoring = true
  dynamic "ephemeral_block_device" {
    for_each = [for ephemeral_block_device in var.ephemeral_block_devices:{
    device_name = ephemeral_block_device.device_name
    virtual_name = ephemeral_block_device.virtual_name
    }]
    content {

      device_name  = ephemeral_block_device.value.device_name
      virtual_name = ephemeral_block_device.value.virtual_name
    }
  }
  iam_instance_profile = aws_iam_instance_profile.launch_config.name
  image_id             = var.image_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  lifecycle {
    create_before_destroy = true
  }
  name_prefix       = var.name
  placement_tenancy = var.placement_tenancy
  dynamic "root_block_device" {
    for_each = [for root_block_device in var.root_block_devices:{
      delete_on_termination = root_block_device.delete_on_termination
      iops                  = root_block_device.iops
      volume_size           = root_block_device.volume_size
      volume_type           = root_block_device.volume_type 
    }]
    content {

      delete_on_termination = root_block_device.value.delete_on_termination
      iops                  = root_block_device.value.iops
      volume_size           = root_block_device.value.volume_size
      volume_type           = root_block_device.value.volume_type
    }
  }
  security_groups = var.security_groups
  user_data       = var.user_data
}

