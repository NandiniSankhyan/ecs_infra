provider "aws" {
  region  = "eu-west-2"
}

terraform {
  backend "s3" {
    bucket = "ecsbucket-greeter"
    key    = "state/terraform.tfstate"
    region = "eu-west-2"
  }
}