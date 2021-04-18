##### Application Load balancer
resource "aws_alb" "ecs_load_balancer" {
  name            = "ecsloadbalancer"
  security_groups = [aws_security_group.lb_asg.id]
  subnets         = [aws_subnet.pub_subnet_1.id, aws_subnet.pub_subnet_2.id]
  tags = {
    Name = "APP ALB"
  }
}

##### ALB Target Group
resource "aws_alb_target_group" "ecs_target_group" {
  name     = "ecstargetgroup"
  port     = "3000"
  protocol = "HTTP"
  vpc_id   = aws_vpc.app_vpc.id

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200,202"
    path                = "/healthcheck/"
    port                = "3000"
    protocol            = "HTTP"
    timeout             = "5"
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_alb.ecs_load_balancer]

  tags = {
    Name = "ECS Target Group"
  }
}

#### ALB Listener
resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = aws_alb.ecs_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.ecs_target_group.arn
    type             = "forward"
  }
}
