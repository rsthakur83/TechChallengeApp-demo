##### Auto Scaling Group Configuration
resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  depends_on           = ["aws_launch_configuration.ecs_launch_configuration", "aws_db_instance.app_db"]
  name                 = var.asg_name
  max_size             = var.max_instance_size
  min_size             = var.min_instance_size
  desired_capacity     = var.desired_capacity
  vpc_zone_identifier  = [aws_subnet.app_subnet_1.id, aws_subnet.app_subnet_2.id]
  launch_configuration = aws_launch_configuration.ecs_launch_configuration.name
  health_check_type    = "ELB"
  tag {
    key                 = "Name"
    value               = "APP ECS"
    propagate_at_launch = true
  }

}
