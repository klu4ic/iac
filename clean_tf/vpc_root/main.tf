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



module "vpc" {
  source  = "../vpc_child"

}
