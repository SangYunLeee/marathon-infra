
################################################################
##               E   C   S                                     #
################################################################

resource "aws_ecs_cluster" "race_point_cluster" {
  name = "tf-race-point-cluster"
}

resource "aws_ecs_service" "ecs_point_service" {
  name                               = "tf-ecs-service"
  cluster                            = aws_ecs_cluster.race_point_cluster.id
  task_definition                    = aws_ecs_task_definition.point_task.arn
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
    target_group_arn = aws_alb_target_group.ecs_point_target_group.arn
    container_name   = "tf-race-point-task"
    container_port   = 5500
  }
}

resource "aws_ecs_task_definition" "point_task" {
  family                   = "tf-race-point-task"
  container_definitions    = <<DEFINITION
  [
    {
      "name": "tf-race-point-task",
      "image": "648098991845.dkr.ecr.ap-northeast-2.amazonaws.com/point:0.1",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 5500,
          "hostPort": 5500
        }
      ],
      "cpu": 0,
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-region": "ap-northeast-2",
          "awslogs-stream-prefix": "app-logstream",
          "awslogs-group": "${aws_cloudwatch_log_group.ecs_service_point_log_group.name}"
        }
      },
      "environment": [
        {
          "name": "TYPEORM_PASSWORD",
          "value": "${var.DB_PASSWORD}"
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

resource "aws_cloudwatch_log_group" "ecs_service_point_log_group" {
  name = "tf-point-ecs-service-loggroup"
}

################################################################
##               A   L   B                                     #
################################################################
resource "aws_lb" "point_lb" {
  name               = "tf-point-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_sg.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_alb_target_group" "ecs_point_target_group" {
  name        = "tf-point-tg"
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

resource "aws_alb_listener" "http_point" {
  load_balancer_arn = aws_lb.point_lb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.ecs_point_target_group.id
    type             = "forward"
  }
}
