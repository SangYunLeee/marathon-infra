module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "tf-record-vpc"
  cidr = "10.2.0.0/16"

  azs = [
    "ap-northeast-2a",
    "ap-northeast-2c"
  ]
  private_subnets = [
    "10.2.101.0/24",
    "10.2.102.0/24"
  ]
  public_subnets = [
    "10.2.1.0/24",
    "10.2.2.0/24"
  ]

  # Single NAT Gateway
  enable_nat_gateway     = false
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

# VPC 엔드포인트 설정
  # priavate subnet 에서 ECR 을 사용하기 위함
resource "aws_vpc_endpoint" "tf_race_vpce_s3" {
  vpc_id               = module.vpc.vpc_id
  service_name         = "com.amazonaws.ap-northeast-2.s3"
  vpc_endpoint_type    = "Gateway"
  route_table_ids      = module.vpc.private_route_table_ids
}

resource "aws_vpc_endpoint" "tf_ecr_endpoint_api" {
  vpc_id               = module.vpc.vpc_id
  service_name         = "com.amazonaws.ap-northeast-2.ecr.api"
  vpc_endpoint_type    = "Interface"
  security_group_ids = [aws_security_group.private_sg.id]
  subnet_ids           = module.vpc.private_subnets
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "tf_ecr_endpoint_dkr" {
  vpc_id               = module.vpc.vpc_id
  service_name         = "com.amazonaws.ap-northeast-2.ecr.dkr"
  vpc_endpoint_type    = "Interface"
  security_group_ids = [aws_security_group.private_sg.id]
  subnet_ids           = module.vpc.private_subnets
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "tf_race_endpoint_logs" {
  vpc_id               = module.vpc.vpc_id
  service_name         = "com.amazonaws.ap-northeast-2.logs"
  vpc_endpoint_type    = "Interface"
  security_group_ids = [aws_security_group.private_sg.id]
  subnet_ids           = module.vpc.private_subnets
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "tf_race_endpoint_sqs" {
  vpc_id               = module.vpc.vpc_id
  service_name         = "com.amazonaws.ap-northeast-2.sqs"
  vpc_endpoint_type    = "Interface"
  security_group_ids = [aws_security_group.private_sg.id]
  subnet_ids           = module.vpc.private_subnets
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "tf_race_endpoint_dynamodb" {
  vpc_id               = module.vpc.vpc_id
  service_name         = "com.amazonaws.ap-northeast-2.dynamodb"
  vpc_endpoint_type    = "Gateway"
  route_table_ids      = module.vpc.private_route_table_ids
}
