#### CloudWatch Alarms #####

### High CPU usage metrics Alarm for ECS APP service
resource "aws_cloudwatch_metric_alarm" "ecs_service_scale_up_alarm" {
  alarm_name          = "ecs_cluster-appecsservice-ECSServiceScaleUpAlarm"
  depends_on          = ["aws_db_instance.app_db", "aws_appautoscaling_target.ecs_target", "aws_ecs_cluster.app_ecs_cluster"]
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = var.period_up
  statistic           = var.statistic
  threshold           = var.threshold_up
  datapoints_to_alarm = var.datapoints_to_alarm_up

  dimensions = {
    ClusterName = var.ecs_cluster
    ServiceName = var.service_name
  }

  alarm_description = "This alarm monitors ECS app service High CPU utilization"
  alarm_actions     = [aws_appautoscaling_policy.scale_up.arn]
  tags = {
    key   = "Name"
    value = "App Service High CPU Alarm"

  }
}

### Low CPU usage metrics Alarm for ECS APP service
resource "aws_cloudwatch_metric_alarm" "ecs_service_scale_down_alarm" {
  depends_on          = ["aws_db_instance.app_db", "aws_appautoscaling_target.ecs_target", "aws_ecs_cluster.app_ecs_cluster"]
  alarm_name          = "ecs_cluster-appecsservice-ECSServiceScaleDownAlarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = var.period_down
  statistic           = var.statistic
  threshold           = var.threshold_down
  datapoints_to_alarm = var.datapoints_to_alarm_down

  dimensions = {
    ClusterName = var.ecs_cluster
    ServiceName = var.service_name
  }

  alarm_description = "This alarm monitors ECS app service Low CPU utilization"
  alarm_actions     = [aws_appautoscaling_policy.scale_down.arn]
  tags = {
    key   = "Name"
    value = "App Service Low CPU Alarm"

  }
}

#### Application AutoScaling Policy Target
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  depends_on         = ["aws_ecs_service.app_ecs_service"]
  resource_id        = "service/ecs_cluster/appecsservice"
  role_arn           = aws_iam_role.ecs_autoscale_role.arn
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


#### Application AutoScaling Policy Resource
resource "aws_appautoscaling_policy" "scale_down" {
  name               = "ecs_cluster-appecsservice-scale-down"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = var.upperbound
      scaling_adjustment          = var.scale_down_adjustment
    }
  }

  depends_on = [aws_appautoscaling_target.ecs_target]
}

#### Application AutoScaling Policy Resource
resource "aws_appautoscaling_policy" "scale_up" {
  name               = "ecs_cluster-appecsservice-scale-up"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_lower_bound = var.lowerbound
      scaling_adjustment          = var.scale_up_adjustment
    }
  }

  depends_on = [aws_appautoscaling_target.ecs_target]
}

### APP ASG High CPU usage metrics Alarm
resource "aws_cloudwatch_metric_alarm" "app-asg-cpu-alarm-scaleup" {
  alarm_name          = "app-asg-cpu-alarm-scaleup"
  alarm_description   = "app-asg-cpu-alarm-scaleup"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.period_up
  statistic           = var.statistic
  threshold           = var.threshold_up
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ecs_autoscaling_group.name
  }

  alarm_actions = [aws_autoscaling_policy.cpu_agents_scale_up.arn]
  tags = {
    key   = "Name"
    value = "APP ASG High CPU Usage Alarm"

  }
}

### APP ASG Low CPU usage metrics Alarm
resource "aws_cloudwatch_metric_alarm" "app-asg-cpu-alarm-scaledown" {
  alarm_name          = "app-asg-cpu-alarm-scaledown"
  alarm_description   = "app-asg-cpu-alarm-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.evaluation_periods
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = var.period_down
  statistic           = var.statistic
  threshold           = var.threshold_down

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ecs_autoscaling_group.name
  }

  alarm_actions = [aws_autoscaling_policy.cpu_agents_scale_down.arn]
  tags = {
    key   = "Name"
    value = "APP ASG Low CPU Usage Alarm"

  }
}

#### ASG Scale up policy
resource "aws_autoscaling_policy" "cpu_agents_scale_up" {
  name                   = "agents-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ecs_autoscaling_group.name
}

#### ASG Scale down policy
resource "aws_autoscaling_policy" "cpu_agents_scale_down" {
  name                   = "agents-scale-down"
  autoscaling_group_name = aws_autoscaling_group.ecs_autoscaling_group.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}
