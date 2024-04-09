##### Create EKS Fargate Role
resource "aws_iam_role" "fargate" {
  count = (var.fargate_profile == true) ? 1 : 0
  name  = "${var.tenant}-${var.name}-eks-fargate-iam-role-${data.aws_region.current.name}-${var.environment}"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

  tags = {
    Name        = "${var.tenant}-${var.name}-eks-fargate-iam-role-${data.aws_region.current.name}-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}

# Attach Role Policy for Fargate Role
resource "aws_iam_role_policy_attachment" "fargate" {
  count      = (var.fargate_profile == true) ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate[0].id
}

# Create Logging Policy for Fargate
resource "aws_iam_role_policy" "fargate" {
  count = (var.fargate_profile == true) ? 1 : 0
  name = "${var.tenant}-${var.name}-fargate-logging-policy-${var.environment}"
  role = aws_iam_role.fargate[0].id

  policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [{
		"Effect": "Allow",
		"Action": [
			"logs:CreateLogStream",
			"logs:CreateLogGroup",
			"logs:DescribeLogStreams",
			"logs:PutLogEvents",
      "logs:PutRetentionPolicy"
		],
		"Resource": "*"
	}]
}
EOF
}

# Create Fargate Profile
resource "aws_eks_fargate_profile" "main" {
  count                  = (var.fargate_profile == true) ? 1 : 0
  fargate_profile_name   = "${var.tenant}-${var.name}-eks-fargate-profile-${var.environment}"
  cluster_name           = aws_eks_cluster.main.name
  pod_execution_role_arn = aws_iam_role.fargate[0].arn
  subnet_ids             = var.pvt_subnet_ids

  selector {
    namespace = "fargate-${var.environment}"
  }

  tags = {
    Name        = "${var.tenant}-${var.name}-eks-fargate-profile-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}
