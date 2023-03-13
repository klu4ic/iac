
# output "vpc_id" {
#   value = module.vpc.vpc_id

# }
# output "public_subnets" {
#   value = module.vpc.public_subnets

# }

# # output "vpc" {  
# #   value = module.vpc
# # }

output "aws_vpc" {
    value = aws_vpc.main123.id
}