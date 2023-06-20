module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "tf-vpc"
  cidr = "10.2.0.0/16"

  azs = [
    "ap-northeast-2a",
    "ap-northeast-2c"
  ]
  private_subnets = [
    "10.2.1.0/24",
    "10.2.2.0/24"
  ]
  public_subnets = [
    "10.2.101.0/24",
    "10.2.102.0/24"
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
