########################################################################################################################
## Get most recent AMI for an ECS-optimized Amazon Linux 2 instance
########################################################################################################################

data "aws_ami" "amazon_linux_2" {
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"]
}

########################################################################################################################
## Launch template for all EC2 instances that are part of the ECS cluster
########################################################################################################################

resource "aws_launch_template" "ecs_launch_template" {
  name          = "EC2_LaunchTemplate-${var.environment}"
  image_id      = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type

  key_name               = aws_key_pair.default.key_name
  vpc_security_group_ids = [var.sg_private]
  user_data              = filebase64("${path.module}/user_data.sh")

  iam_instance_profile {
    name = "ecsInstanceRole"
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 30
      volume_type = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "ecs-instance"
    }
  }
}
