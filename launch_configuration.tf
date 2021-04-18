##### Launch Configuration

resource "aws_launch_configuration" "ecs_launch_configuration" {
  name                 = "ecs_launch_configuration"
  image_id             = var.ami_id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ecs-instance-profile.id
  security_groups      = [aws_security_group.app_asg.id]
  root_block_device {
    volume_type           = "standard"
    volume_size           = 100
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }
  user_data = <<EOF
                                  #!/bin/bash
                                  echo ECS_CLUSTER=ecs_cluster >> /etc/ecs/ecs.config
                                  EOF
}
