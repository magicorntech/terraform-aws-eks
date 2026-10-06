resource "aws_eks_addon" "vpccni" {
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = "vpc-cni"
  addon_version               = var.vpccni_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

#   configuration_values = jsonencode({
#     replicaCount = 4
#     resources = {
#       limits = {
#         cpu    = "100m"
#         memory = "150Mi"
#       }
#       requests = {
#         cpu    = "100m"
#         memory = "150Mi"
#       }
#     }
#   })

  depends_on = [
    aws_eks_node_group.main,
    aws_eks_node_group.extra
  ]

  tags = {
    Name        = "${var.tenant}-${var.name}-eks-addon-vpc-cni-${data.aws_region.current.name}-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = "coredns"
  addon_version               = var.coredns_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

#   configuration_values = jsonencode({
#     replicaCount = 4
#     resources = {
#       limits = {
#         cpu    = "100m"
#         memory = "150Mi"
#       }
#       requests = {
#         cpu    = "100m"
#         memory = "150Mi"
#       }
#     }
#   })

  depends_on = [
    aws_eks_node_group.main,
    aws_eks_node_group.extra
  ]

  tags = {
    Name        = "${var.tenant}-${var.name}-eks-addon-coredns-${data.aws_region.current.name}-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}

resource "aws_eks_addon" "kubeproxy" {
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = "kube-proxy"
  addon_version               = var.kubeproxy_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

#   configuration_values = jsonencode({
#     replicaCount = 4
#     resources = {
#       limits = {
#         cpu    = "100m"
#         memory = "150Mi"
#       }
#       requests = {
#         cpu    = "100m"
#         memory = "150Mi"
#       }
#     }
#   })

  depends_on = [
    aws_eks_node_group.main,
    aws_eks_node_group.extra
  ]

  tags = {
    Name        = "${var.tenant}-${var.name}-eks-addon-kube-proxy-${data.aws_region.current.name}-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}

resource "aws_eks_addon" "ebscsi" {
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = "aws-ebs-csi-driver"
  addon_version               = var.ebscsi_version
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

#   configuration_values = jsonencode({
#     replicaCount = 4
#     resources = {
#       limits = {
#         cpu    = "100m"
#         memory = "150Mi"
#       }
#       requests = {
#         cpu    = "100m"
#         memory = "150Mi"
#       }
#     }
#   })

  depends_on = [
    aws_eks_node_group.main,
    aws_eks_node_group.extra
  ]

  tags = {
    Name        = "${var.tenant}-${var.name}-eks-addon-ebs-csi-${data.aws_region.current.name}-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}

resource "aws_eks_addon" "efscsi" {
  count                       = length(var.efs_drives) > 0 ? 1 : 0
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = "aws-efs-csi-driver"
  addon_version               = var.efscsi_version
  service_account_role_arn    = aws_iam_role.efs_csi[0].arn
  resolve_conflicts_on_create = "OVERWRITE"
  resolve_conflicts_on_update = "OVERWRITE"

  depends_on = [
    aws_eks_node_group.main,
    aws_eks_node_group.extra,
    aws_iam_role_policy_attachment.AmazonEFSCSIDriverPolicy
  ]

  tags = {
    Name        = "${var.tenant}-${var.name}-eks-addon-efs-csi-${data.aws_region.current.name}-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}