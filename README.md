# terraform-aws-eks

Magicorn made Terraform Module for AWS Provider
--
```
module "eks" {
  source         = "magicorntech/eks/aws"
  version        = "0.6.0"
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
  efscsi_version       = "v2.1.8-eksbuild.1"
  enable_aws_cicd      = true # 1
  fargate_profile      = false

  # Node Configuration (you may set empty map {})
  node_groups = {
    main = {
      capacity_type  = "ON_DEMAND"
      ami_type       = "AL2023_x86_64_STANDARD"
      disk_size      = 30
      instance_types = ["t3.medium", "t3a.medium"]
      scaling_config = { desired = 3, min = 3, max = 3 }
      hop_limit      = 3
    }
    extra = {
      capacity_type  = "SPOT"
      ami_type       = "AL2023_x86_64_STANDARD"
      disk_size      = 30
      instance_types = ["t3.medium", "t3a.medium"]
      scaling_config = { desired = 0, min = 0, max = 25 }
      iam_role       = "arn:aws:iam::123456789012:role/custom-node" # 2
    }
    tmp = {
      capacity_type  = "SPOT"
      ami_type       = "AL2023_ARM_64_STANDARD"
      disk_size      = 30
      instance_types = ["t4g.large"]
      scaling_config = { desired = 0, min = 0, max = 25 }
    }
    gpu = {
      capacity_type  = "ON_DEMAND"
      ami_type       = "AL2023_x86_64_NVIDIA"
      disk_size      = 100
      instance_types = ["g4dn.xlarge"]
      scaling_config = { desired = 1, min = 1, max = 1 }
      taints = [{
        key    = "nvidia.com/gpu"
        value  = "true"
        effect = "NO_SCHEDULE"
      }]
    }
  }

  # Additional EFS Configuration (you may set empty map {})
  efs_drives = {
    shared = {
      encryption                      = true
      kms_key_id                      = null # 3
      performance_mode                = "generalPurpose" # or "maxIO"
      throughput_mode                 = "bursting"       # "provisioned" or "elastic"
      provisioned_throughput_in_mibps = null             # set only if "provisioned" throughput_mode
    }
  }
}
```

## Notes
1) Disable if you want to use external CI/CD solutions like GitLab or Bitbucket. Leaving true deploys the required permissions for AWS Code Suite.
2) Each `node_groups` map key becomes one launch template and one node group (`eks-<key>lt` / `eks-<key>node`). Omit a key to skip that group. Optional `taints` list applies EKS taints (e.g. GPU `nvidia.com/gpu=true:NoSchedule`). NVIDIA AMI types skip burstable `credit_specification`. Optional `iam_role`: omit to use the module node role, set an ARN to use that role, set `""` or `null` for no role. Optional `hop_limit` sets IMDS `http_put_response_hop_limit` (defaults to `2` if omitted). Use DNS-safe keys (`main`, `extra`, `gpu`, `ml`).
3) Works better with magicorn-aws-kms module. Set `efs_drives = {}` to skip EFS, the CSI add-on, and StorageClass files. Each map key becomes one file system and one StorageClass (`efs-<key>`) in `_deployables/5_efs_storageclass.yaml`. Use DNS-safe keys (`shared`, `mlflow`).
