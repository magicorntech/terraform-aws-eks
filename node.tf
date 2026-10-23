##### Create Node Groups (one per node_groups map key)
resource "aws_eks_node_group" "main" {
  for_each        = var.node_groups
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.tenant}-${var.name}-eks-${each.key}node-${var.environment}"
  node_role_arn   = contains(keys(each.value), "iam_role") ? (each.value.iam_role == "" ? null : each.value.iam_role) : aws_iam_role.node.arn
  subnet_ids      = var.eks_subnet_ids
  capacity_type   = each.value.capacity_type
  ami_type        = each.value.ami_type
  instance_types  = each.value.instance_types
  version         = var.eks_version

  launch_template {
    id      = aws_launch_template.main[each.key].id
    version = "$Latest"
  }

  scaling_config {
    desired_size = lookup(each.value.scaling_config, "desired")
    min_size     = lookup(each.value.scaling_config, "min")
    max_size     = lookup(each.value.scaling_config, "max")
  }

  dynamic "taint" {
    for_each = try(each.value.taints, [])
    content {
      key    = taint.value.key
      value  = taint.value.value
      effect = taint.value.effect
    }
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]

  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size,
      launch_template[0].version
    ]
  }

  tags = {
    Name        = "${var.tenant}-${var.name}-eks-${each.key}node-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}
