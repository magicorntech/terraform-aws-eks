##### Create Main Node Group
resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.tenant}-${var.name}-eks-mainnode-${var.environment}"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.eks_subnet_ids
  capacity_type   = var.main_capacity_type
  ami_type        = var.main_ami_type
  instance_types  = var.main_instance_types
  version         = var.eks_version

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }

  scaling_config {
    desired_size = lookup(var.main_scaling_config, "desired")
    min_size     = lookup(var.main_scaling_config, "min")
    max_size     = lookup(var.main_scaling_config, "max")
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
    Name        = "${var.tenant}-${var.name}-eks-mainnode-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}


##### Create Extra Node Group
resource "aws_eks_node_group" "extra" {
  count           = (var.extra_nodes_deploy == true) ? 1 : 0
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.tenant}-${var.name}-eks-extranode-${var.environment}"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.eks_subnet_ids
  capacity_type   = var.extra_capacity_type
  ami_type        = var.extra_ami_type
  instance_types  = var.extra_instance_types
  version         = var.eks_version

  launch_template {
    id      = aws_launch_template.extra[0].id
    version = "$Latest"
  }

  scaling_config {
    desired_size = lookup(var.extra_scaling_config, "desired")
    min_size     = lookup(var.extra_scaling_config, "min")
    max_size     = lookup(var.extra_scaling_config, "max")
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
    Name        = "${var.tenant}-${var.name}-eks-extranode-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}

##### Create Temporary Node Group
resource "aws_eks_node_group" "tmp" {
  count           = (var.tmp_nodes_deploy == true) ? 1 : 0
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.tenant}-${var.name}-eks-tmpnode-${var.environment}"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.eks_subnet_ids
  capacity_type   = var.tmp_capacity_type
  ami_type        = var.tmp_ami_type
  instance_types  = var.tmp_instance_types
  version         = var.eks_version

  launch_template {
    id      = aws_launch_template.tmp[0].id
    version = "$Latest"
  }

  scaling_config {
    desired_size = lookup(var.tmp_scaling_config, "desired")
    min_size     = lookup(var.tmp_scaling_config, "min")
    max_size     = lookup(var.tmp_scaling_config, "max")
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
    Name        = "${var.tenant}-${var.name}-eks-tmpnode-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}

