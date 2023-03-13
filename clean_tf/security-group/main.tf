terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.57.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

 
terraform {
  backend "s3" {
    bucket = "state-bucket-2022-random" // Bucket where to SAVE Terraform State
    key    = "dev/sg/terraform.tfstate"             // Object name in the bucket to SAVE Terraform State
    region = "eu-west-1"                                 // Region where bycket created
  }
}

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "state-bucket-2022-random" // Bucket where to SAVE Terraform State
    key    = "dev/vpc/terraform.tfstate"             // Object name in the bucket to SAVE Terraform State
    region = "eu-west-1" 
  }
}

module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.17.1"
  name        = "user-service"
  description = "Instance ssh Security group"
  vpc_id      = data.terraform_remote_state.vpc.outputs.vpc_id


  ingress_cidr_blocks      = ["10.0.101.0/16"]

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

}
