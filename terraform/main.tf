
provider "aws" {
  region = var.region
}


terraform {
  backend "s3" {
    bucket = "uaebucketprod"
    key    = "terraform.tfstate"
    region =  "us-east-2"
  }
}


module "dc1" {
  source                      = "./modules/provider/aws"
  stage                       = var.stage
  name                        = var.name
  region                      = var.region
  namespace                   = var.namespace
  attributes                  = var.attributes
  availability_zones          = var.availability_zones
  tags                        = var.tags
  instance_type               = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  health_check_type           = var.health_check_type
  min_size                    = var.min_size
  max_size                    = var.max_size
  wait_for_capacity_timeout   = var.wait_for_capacity_timeout
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
  enabled_cluster_log_types                      = var.enabled_cluster_log_types
  cluster_log_retention_period                   = var.cluster_log_retention_period
  ecr_registry = var.ecr_registry
}

data "aws_eks_cluster" "cluster" {
  name = module.dc1.eks_cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.dc1.eks_cluster_id
}
