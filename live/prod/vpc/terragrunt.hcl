terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git//?ref=v3.19.0"
}

# Automatically find the root terragrunt.hcl and inherit its
# configuration
include {
  path = find_in_parent_folders()
}

inputs = {
  name            = "my-vpc-prod"
  cidr            = "10.0.0.0/16"
  azs             = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]
  public_subnets  = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"]
}



