# Create an ECS cluster
resource "aws_ecs_cluster" "race_cluster" {
  name = "race-record-cluster"
}

resource "aws_ecs_task_definition" "app_task" {
  family                   = "tf-race-record-task" # Name your task
  container_definitions    = <<DEFINITION
  [
    {
      "name": "tf-race-record-task",
      "image": "${var.ECR_IMAGE_URL}",
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
          "awslogs-group": "${aws_cloudwatch_log_group.my_ecs_service_log_group.name}"
        }
      },
      "environment": [
        {
          "name": "TYPEORM_PASSWORD",
          "value": "${var.DB_PASSWORD}"
        },
        {
          "name": "QUEUE_URL",
          "value": "${var.QUEUE_URL}"
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

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "tf-record-ecsTaskExecutionRole"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecsTaskExecutionRole_policy" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "my_ecs_service_log_group" {
  name = "tf-record-ecs-service-loggroup"
}

################################################################
##               A   L   B                                     #
################################################################
resource "aws_lb" "main_lb" {
  name               = "tf-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_sg.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_alb_target_group" "my_ecs_target_group" {
  name        = "tf-app-tg"
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

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.main_lb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.my_ecs_target_group.id
    type             = "forward"
  }
}

################################################################
##               E   C   S                                     #
################################################################

resource "aws_ecs_service" "my_ecs_service" {
  name                               = "tf-ecs-service"
  cluster                            = aws_ecs_cluster.race_cluster.id
  task_definition                    = aws_ecs_task_definition.app_task.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [aws_security_group.public_sg.id]
    subnets          = module.vpc.public_subnets
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.my_ecs_target_group.arn
    container_name   = "tf-race-record-task"
    container_port   = 5500
  }
}
