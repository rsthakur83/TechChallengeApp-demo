data "aws_ecs_task_definition" "app" {
  task_definition = aws_ecs_task_definition.app.family
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}
resource "aws_ecs_task_definition" "app" {

  depends_on            = ["aws_db_instance.app_db"]
  family                = "app"
  execution_role_arn    = data.aws_iam_role.ecs_task_execution_role.arn
  container_definitions = <<DEFINITION
[
  {
    "name": "app",
    "image": "account-id.dkr.ecr.aws-region.amazonaws.com/ecr-repo:release-number",
    "essential": true,
    "secrets": [
        {
          "name": "VTT_DBHOST",
          "valueFrom": "arn:aws:ssm:aws-region:account-id:parameter/dbhostname"
        },
        {
          "name": "VTT_DBPASSWORD",
          "valueFrom": "arn:aws:ssm:aws-region:account-id:parameter/dbpassword"
        },
        {
          "name": "VTT_DBNAME",
          "valueFrom": "arn:aws:ssm:aws-region:account-id:parameter/dbname"
        },
        {
          "name": "VTT_DBUSER",
          "valueFrom": "arn:aws:ssm:aws-region:account-id:parameter/dbusername"
        }
    ],
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ],
    "memory": 100,
    "cpu": 10
  }
]
DEFINITION
  tags = {
    Name = "APP ECS Service Task Definition"
  }
}
