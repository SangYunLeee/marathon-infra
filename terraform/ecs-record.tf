
################################################################
##               E   C   S                                     #
################################################################

resource "aws_ecs_cluster" "race_record_cluster" {
  name = "tf-race-record-cluster"
}

resource "aws_ecs_service" "ecs_record_service" {
  name                               = "tf-ecs-service"
  cluster                            = aws_ecs_cluster.race_record_cluster.id
  task_definition                    = aws_ecs_task_definition.record_task.arn
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
    target_group_arn = aws_alb_target_group.ecs_record_target_group.arn
    container_name   = "tf-race-record-task"
    container_port   = 5500
  }
}

resource "aws_ecs_task_definition" "record_task" {
  depends_on = [ module.db ]
  family                   = "tf-race-record-task"
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
          "awslogs-group": "${aws_cloudwatch_log_group.ecs_record_service_log_group.name}"
        }
      },
      "environment": [
        {
          "name": "TYPEORM_HOST",
          "value": "${module.db.db_instance_address}"
        },
        {
          "name": "TYPEORM_USERNAME",
          "value": "${var.DB_USERNAME}"
        },
        {
          "name": "TYPEORM_PASSWORD",
          "value": "${var.DB_PASSWORD}"
        },
        {
          "name": "TYPEORM_DATABASE",
          "value": "${var.DB_DATABASE}"
        },
        {
          "name": "TYPEORM_PORT",
          "value": "${var.DB_PORT}"
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
  task_role_arn = aws_iam_role.ecsTaskExecutionRole.arn
}

resource "aws_cloudwatch_log_group" "ecs_record_service_log_group" {
  name = "tf-record-ecs-service-loggroup"
}

################################################################
##               A   L   B                                     #
################################################################
resource "aws_lb" "record_lb" {
  name               = "tf-record-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.public_sg.id]
  subnets            = module.vpc.public_subnets
}

resource "aws_alb_target_group" "ecs_record_target_group" {
  name        = "tf-record-tg"
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

resource "aws_alb_listener" "http_record" {
  load_balancer_arn = aws_lb.record_lb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.ecs_record_target_group.id
    type             = "forward"
  }
}

# ################################################################
# ##               R    D   S                                    #
# ################################################################

module "db" {
  source  = "terraform-aws-modules/rds/aws"

  identifier = "race-db"

  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t2.micro"
  allocated_storage = 20

  db_name  = var.DB_DATABASE
  username = var.DB_USERNAME
  password = var.DB_PASSWORD
  port     = "3306"

  create_random_password = false
  iam_database_authentication_enabled = false

  vpc_security_group_ids = [aws_security_group.private_sg.id]

  skip_final_snapshot = true

  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets

  family = "mysql5.7"

  major_engine_version = "5.7"
  storage_encrypted = false
}
