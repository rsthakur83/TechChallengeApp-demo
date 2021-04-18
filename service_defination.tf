resource "aws_ecs_service" "app_ecs_service" {
  lifecycle {
    create_before_destroy = true
  }
  name     = "appecsservice"
  iam_role = aws_iam_role.ecs_service_role.name
  cluster  = aws_ecs_cluster.app_ecs_cluster.id

  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 2

  load_balancer {
    target_group_arn = aws_alb_target_group.ecs_target_group.arn
    container_port   = 3000
    container_name   = "app"
  }
  tags = {
    Name = "APP ECS Service"
  }

}
