# terraform-aws-eks

Magicorn made Terraform Module for AWS Provider
--
```
module "eks" {
  source         = "magicorntech/eks/aws"
  version        = "0.1.0"
  tenant         = var.tenant
  name           = var.name
  environment    = var.environment
  vpc_id         = module.vpc.vpc_id
  cidr_block     = module.vpc.cidr_block
  pvt_subnet_ids = module.vpc.pvt_subnet_ids
  eks_subnet_ids = module.vpc.eks_subnet_ids
  additional_ips = ["10.10.0.0/16", "172.31.0.0/16"] # should be set empty []

  # EKS Configuration
  eks_version          = "1.30"
  vpccni_version       = "v1.19.0-eksbuild.1"
  coredns_version      = "v1.11.1-eksbuild.8"
  kubeproxy_version    = "v1.30.6-eksbuild.3"
  ebscsi_version       = "v1.38.1-eksbuild.1"
  main_capacity_type   = "ON_DEMAND"
  extra_capacity_type  = "SPOT"
  main_disk_size       = 30
  extra_disk_size      = 30
  main_instance_types  = ["t3.medium", "t3a.medium"]
  extra_instance_types = ["t3.medium", "t3a.medium"]
  main_scaling_config  = {desired=3, min=3, max=3}
  extra_scaling_config = {desired=0, min=0, max=25}
  enable_aws_cicd      = true # 1
  fargate_profile      = false
}
```

## Notes
1) Disable if you want to use external CI/CD solutions like GitLab or Bitbucket. Leaving true deploys the required permissions for AWS Code Suite.