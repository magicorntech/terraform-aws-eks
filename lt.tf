##### Create Main Launch Template
resource "aws_launch_template" "main" {
  for_each = var.node_groups
  name     = "${var.tenant}-${var.name}-eks-${each.key}lt-${var.environment}"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = each.value.disk_size
    }
  }

  # credit_specification only applies to burstable instances; omit for NVIDIA/GPU AMIs
  dynamic "credit_specification" {
    for_each = can(regex("NVIDIA", each.value.ami_type)) ? [] : [1]
    content {
      cpu_credits = "unlimited"
    }
  }

  ebs_optimized = true

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = lookup(each.value, "imds_http_tokens", "optional")
    instance_metadata_tags      = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = lookup(each.value, "hop_limit", 2)
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.tenant}-${var.name}-eks-${each.key}node-${var.environment}"
      Tenant      = var.tenant
      Project     = var.name
      Environment = var.environment
      Maintainer  = "Magicorn"
      Terraform   = "yes"
    }
  }

  tags = {
    Name        = "${var.tenant}-${var.name}-eks-${each.key}lt-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }

  lifecycle {
    precondition {
      condition     = contains(["required", "optional"], lookup(each.value, "imds_http_tokens", "optional"))
      error_message = "node_groups.${each.key}.imds_http_tokens sadece \"required\" veya \"optional\" olabilir."
    }
  }
}
