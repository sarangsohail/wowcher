provider "aws" {
  region = "us-west-2"
}

# Define the ECS task definition
resource "aws_ecs_task_definition" "test" {
  family                   = "test"
  container_definitions    = jsonencode([
    {
      name  = "test"
      image = "123456789012.dkr.ecr.us-west-2.amazonaws.com/test:latest"
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 0
        }
      ],
      environment = [
        {
          name  = "JAVA_OPTS"
          value = "-Xmx512m"
        }
      ]
    }
  ])
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
}

# Define the ECS service
resource "aws_ecs_service" "test" {
  name            = "test"
  task_definition = aws_ecs_task_definition.test.arn
  desired_count   = 1

  # Use the private subnets for the ECS tasks
  launch_type     = "FARGATE"
  network_configuration {
    security_groups = [aws_security_group.test.id]
    subnets         = var.private_subnet_ids
  }

  # Enable autoscaling based on CPU and memory usage
  depends_on = [aws_appautoscaling_target.test_cpu, aws_appautoscaling_target.test_memory]
  deployment_controller {
    type = "ECS"
  }
  enable_ecs_managed_tags = true

  scaling_configuration {
    max_capacity       = 10
    min_capacity       = 1
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

# Define the security group for the ECS tasks
resource "aws_security_group" "test" {
  name_prefix = "test"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_ids
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define the CloudWatch alarms for autoscaling
resource "aws_cloudwatch_metric_alarm" "test_cpu" {
  alarm_name          = "test-cpu"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  dimensions = {
    ServiceName = aws_ecs_service.test.name
    ClusterName = aws_ecs_cluster.test.name
  }
}