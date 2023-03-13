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
    key    = "dev/ec2/terraform.tfstate"             // Object name in the bucket to SAVE Terraform State
    region = "eu-west-1"                                 // Region where bycket created
  }
}

data "terraform_remote_state" "security-group" {
  backend = "s3"
  config = {
    bucket = "state-bucket-2022-random" // Bucket where to SAVE Terraform State
    key    = "dev/sg/terraform.tfstate"             // Object name in the bucket to SAVE Terraform State
    region = "eu-west-1" 
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



module "ec2-instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "4.3.0"
  name                   = "single-instance"
  ami                    = "ami-ebd02392"
  instance_type          = "t2.micro"
#   key_name               = "user1"
  monitoring             = false
  vpc_security_group_ids = [data.terraform_remote_state.security-group.outputs.security_group_id]
  subnet_id              = data.terraform_remote_state.vpc.outputs.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

}

