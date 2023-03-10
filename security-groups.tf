resource "aws_security_group" "ecs_service_sg" {
  name_prefix = "ecs-service-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = var.app_container_port
    to_port     = var.app_container_port
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_blocks
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ecs_tasks_sg" {
  name_prefix = "ecs-tasks-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = var.app_container_port
    to_port     = var.app_container_port
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs_service_sg.id]
  }
}

