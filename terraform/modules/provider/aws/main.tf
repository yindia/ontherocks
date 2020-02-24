locals {
  eks_worker_ami_name_filter = "amazon-eks-node-${var.kubernetes_version}*"
}

 module "label" {
    source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=master"
    namespace  = var.namespace
    name       = var.name
    stage      = var.stage
    delimiter  = var.delimiter
    attributes = compact(concat(var.attributes, list("cluster")))
    tags       = var.tags
  }


module "eks_vpc" {
  source     = "./vpc"
  stage      = var.stage
  name       = var.name
  region     = var.region
  namespace  = var.namespace
  attributes = var.attributes
  tags       = var.tags
  availability_zones = var.availability_zones
}

module "cluster" {
  source                      = "./eks"
  namespace                   = var.namespace
  stage                       = var.stage
  name                        = var.name
  region                      = var.region
  attributes                  = var.attributes
  instance_type               = var.instance_type
  tags       = var.tags
  eks_worker_ami_name_filter  = local.eks_worker_ami_name_filter
  vpc_id                      = module.eks_vpc.vpc_id
  subnet_ids                  = module.eks_vpc.public_subnet_ids
  associate_public_ip_address = var.associate_public_ip_address
  health_check_type           = var.health_check_type
  min_size                    = var.min_size
  max_size                    = var.max_size
  wait_for_capacity_timeout   = var.wait_for_capacity_timeout
  cluster_name                = module.label.id
  availability_zones          = var.availability_zones
  # Auto-scaling policies and CloudWatch metric alarms
  autoscaling_policies_enabled           = var.autoscaling_policies_enabled
  cpu_utilization_high_threshold_percent = var.cpu_utilization_high_threshold_percent
  cpu_utilization_low_threshold_percent  = var.cpu_utilization_low_threshold_percent

  kubernetes_version     = var.kubernetes_version
  kubeconfig_path        = var.kubeconfig_path
  local_exec_interpreter = var.local_exec_interpreter

  configmap_auth_template_file = var.configmap_auth_template_file
  configmap_auth_file          = var.configmap_auth_file
  oidc_provider_enabled        = var.oidc_provider_enabled

  install_aws_cli                                = var.install_aws_cli
  install_kubectl                                = var.install_kubectl
  kubectl_version                                = var.kubectl_version
  jq_version                                     = var.jq_version
  external_packages_install_path                 = var.external_packages_install_path
  aws_eks_update_kubeconfig_additional_arguments = var.aws_eks_update_kubeconfig_additional_arguments
  aws_cli_assume_role_arn                        = var.aws_cli_assume_role_arn
  aws_cli_assume_role_session_name               = var.aws_cli_assume_role_session_name

  enabled_cluster_log_types    = var.enabled_cluster_log_types
  cluster_log_retention_period = var.cluster_log_retention_period

}

resource "aws_ecr_repository" "betaapp" {
  name              =  var.ecr_registry
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

