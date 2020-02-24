



module "eks_workers" {
  source                             = "git::https://github.com/cloudposse/terraform-aws-eks-workers.git?ref=tags/0.11.0"
  namespace                          = var.namespace
  stage                              = var.stage
  name                               = var.name
  attributes                         = var.attributes
  instance_type                      = var.instance_type
  vpc_id                             = var.vpc_id
  subnet_ids                         = var.subnet_ids
  associate_public_ip_address        = var.associate_public_ip_address
  health_check_type                  = var.health_check_type
  min_size                           = var.min_size
  max_size                           = var.max_size
  wait_for_capacity_timeout          = var.wait_for_capacity_timeout
  cluster_name                       = var.cluster_name
  cluster_endpoint                   = module.eks_cluster.eks_cluster_endpoint
  cluster_certificate_authority_data = module.eks_cluster.eks_cluster_certificate_authority_data
  cluster_security_group_id          = module.eks_cluster.security_group_id

  # Auto-scaling policies and CloudWatch metric alarms
  autoscaling_policies_enabled           = var.autoscaling_policies_enabled
  cpu_utilization_high_threshold_percent = var.cpu_utilization_high_threshold_percent
  cpu_utilization_low_threshold_percent  = var.cpu_utilization_low_threshold_percent
  
}

module "eks_cluster" {
  source                 = "git::https://github.com/cloudposse/terraform-aws-eks-cluster.git?ref=master"
  namespace              = var.namespace
  stage                  = var.stage
  name                   = var.name
  attributes             = var.attributes
  region                 = var.region
  vpc_id                 = var.vpc_id
  subnet_ids             = var.subnet_ids
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

  workers_role_arns          = [module.eks_workers.workers_role_arn]
  workers_security_group_ids = [module.eks_workers.security_group_id]

}
