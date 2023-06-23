# Create an ECS cluster
resource "aws_ecs_cluster" "race_user_cluster" {
  name = "tf-race-user-cluster"
}

resource "aws_ecs_task_definition" "app_user_task" {
  family                   = "tf-race-user-task"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "tf-race-user-task",
      "image": "648098991845.dkr.ecr.ap-northeast-2.amazonaws.com/users:latest",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ],
      "cpu": 0,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-region": "ap-northeast-2",
          "awslogs-stream-prefix": "app-logstream",
          "awslogs-group": "${aws_cloudwatch_log_group.ecs_user_service_log_group.name}"
        }
      },
      "environment": [
        {
          "name": "AWS_ACCESS_KEY_ID",
          "value": "${var.ACCESS_KEY_ID}"
        },
        {
          "name": "AWS_SECRET_ACCESS_KEY",
          "value": "${var.SECRET_KEY}"
        }
      ]
    }
  ]
  DEFINITION
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 2048
  cpu                      = 512
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn
}

resource "aws_cloudwatch_log_group" "ecs_user_service_log_group" {
  name = "tf-ecs-service-loggroup"
}

################################################################
##               A   L   B                                     #
################################################################
resource "aws_lb" "user_lb" {
  name               = "tf-race-user-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_sg.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_alb_target_group" "user_target_group" {
  name        = "tf-user-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

resource "aws_alb_listener" "user_http" {
  load_balancer_arn = aws_lb.user_lb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.user_target_group.id
    type             = "forward"
  }
}

################################################################
##               E   C   S                                     #
################################################################

resource "aws_ecs_service" "user_ecs_service" {
  name                               = "tf-race-user-sv"
  cluster                            = aws_ecs_cluster.race_user_cluster.id
  task_definition                    = aws_ecs_task_definition.app_user_task.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [aws_security_group.public_sg.id]
    subnets          = module.vpc.private_subnets
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.user_target_group.arn
    container_name   = "tf-race-user-task"
    container_port   = 3000
  }
}
