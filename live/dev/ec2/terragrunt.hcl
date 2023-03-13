terraform {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-ec2-instance.git//?ref=v4.3.0"
}

# Automatically find the root terragrunt.hcl and inherit its
# configuration
include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path                             = "../vpc"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "terragrunt-info", "show"] # Configure mock outputs for the "init", "validate", "plan" commands that are returned when there are no outputs available (e.g the module hasn't been applied yet.)
  mock_outputs = {
    public_subnets = ["public-subnet-fake-id"]
  }
}

dependency "security-group" {
  config_path                             = "../security-group"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan", "terragrunt-info", "show"] # Configure mock outputs for the "init", "validate", "plan" commands that are returned when there are no outputs available (e.g the module hasn't been applied yet.)
  mock_outputs = {
    security_group_id = "security-group-fake-id"
  }
}

dependencies {
  paths = ["../vpc", "../security-group"]
}

inputs = {
  name                   = "single-instance"
  ami                    = "ami-ebd02392"
  instance_type          = "t2.micro"
  monitoring             = false
  vpc_security_group_ids = [dependency.security-group.outputs.security_group_id]
  subnet_id              = dependency.vpc.outputs.public_subnets[0]
}



