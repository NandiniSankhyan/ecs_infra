module "vpc" {
  source         = "terraform-aws-modules/vpc/aws"
  version        =  "3.14.2"
  name           = "ecs_provisioning"
  cidr           = "10.0.0.0/16"
  azs            = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  tags = {
    "ManagedBy" = "Terraform"
  }
}

data "aws_vpc" "main" {
  id = module.vpc.vpc_id
}