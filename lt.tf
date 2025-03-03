##### Create Main Launch Template
resource "aws_launch_template" "main" {
  name = "${var.tenant}-${var.name}-eks-mainlt-${var.environment}"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.main_disk_size
    }
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  ebs_optimized = true

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    instance_metadata_tags      = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 2
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.tenant}-${var.name}-eks-mainnode-${var.environment}"
      Tenant      = var.tenant
      Project     = var.name
      Environment = var.environment
      Maintainer  = "Magicorn"
      Terraform   = "yes"
    }
  }

  tags = {
    Name        = "${var.tenant}-${var.name}-eks-mainlt-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}

##### Create Extra Launch Template
resource "aws_launch_template" "extra" {
  count = (var.extra_nodes_deploy == true) ? 1 : 0
  name  = "${var.tenant}-${var.name}-eks-extralt-${var.environment}"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.extra_disk_size
    }
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  ebs_optimized = true

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    instance_metadata_tags      = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 2
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.tenant}-${var.name}-eks-extranode-${var.environment}"
      Tenant      = var.tenant
      Project     = var.name
      Environment = var.environment
      Maintainer  = "Magicorn"
      Terraform   = "yes"
    }
  }

  tags = {
    Name        = "${var.tenant}-${var.name}-eks-extralt-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}

##### Create Temporary Launch Template
resource "aws_launch_template" "tmp" {
  count = (var.tmp_nodes_deploy == true) ? 1 : 0
  name  = "${var.tenant}-${var.name}-eks-tmplt-${var.environment}"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.tmp_disk_size
    }
  }

  credit_specification {
    cpu_credits = "unlimited"
  }

  ebs_optimized = true

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    instance_metadata_tags      = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 2
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.tenant}-${var.name}-eks-tmpnode-${var.environment}"
      Tenant      = var.tenant
      Project     = var.name
      Environment = var.environment
      Maintainer  = "Magicorn"
      Terraform   = "yes"
    }
  }

  tags = {
    Name        = "${var.tenant}-${var.name}-eks-tmplt-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}
