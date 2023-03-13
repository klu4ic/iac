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
    key    = "dev/vpc/terraform.tfstate"             // Object name in the bucket to SAVE Terraform State
    region = "eu-west-1"                                 // Region where bycket created
  }
}


# module "vpc" {
#   source          = "../../modules/vpc"
#   tf_state_key    = var.key
#   tf_state_bucket = var.bucket
#   project         = var.my_project 
#   ......
#   ......
# }


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"
  name = "my-vpc"
  cidr = "10.0.0.0/16"
  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  #   enable_nat_gateway = true
  #   enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
