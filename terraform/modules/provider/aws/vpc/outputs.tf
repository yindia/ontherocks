output "public_subnet_cidrs" {
  value = module.subnets.public_subnet_cidrs
}

output "private_subnet_cidrs" {
  value = module.subnets.private_subnet_cidrs
}

output "public_subnet_ids" {
  value = module.subnets.public_subnet_ids
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
