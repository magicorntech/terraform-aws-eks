locals {
  efs_mounts = {
    for pair in flatten([
      for drive, cfg in var.efs_drives : [
        for az, subnet in var.eks_subnet_ids : {
          key       = "${drive}-${az}"
          drive     = drive
          subnet_id = subnet
        }
      ]
    ]) : pair.key => pair
  }
}

resource "aws_efs_file_system" "main" {
  for_each                        = var.efs_drives
  encrypted                       = (each.value.encryption == true) ? true : false
  kms_key_id                      = (each.value.encryption == true) ? each.value.kms_key_id : null
  performance_mode                = each.value.performance_mode
  throughput_mode                 = each.value.throughput_mode
  provisioned_throughput_in_mibps = each.value.provisioned_throughput_in_mibps

  tags = {
    Name        = "${var.tenant}-${var.name}-eks-efs-${each.key}-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}

resource "aws_security_group" "efs" {
  count       = length(var.efs_drives) > 0 ? 1 : 0
  name        = "${var.tenant}-${var.name}-eks-efs-sg-${var.environment}"
  description = "Managed by Magicorn"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 2049
    to_port     = 2049
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.tenant}-${var.name}-eks-efs-sg-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}

resource "aws_efs_mount_target" "main" {
  for_each        = local.efs_mounts
  file_system_id  = aws_efs_file_system.main[each.value.drive].id
  subnet_id       = each.value.subnet_id
  security_groups = [aws_security_group.efs[0].id]
}
