#### ECS Cluster Name
resource "aws_ecs_cluster" "app_ecs_cluster" {
  name = var.ecs_cluster
  tags = {
    Name = "ECS Cluster Name"
  }
}

