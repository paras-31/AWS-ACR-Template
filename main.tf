# Policy used by both private and public repositories
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}


data "aws_iam_policy_document" "repository" {
  count = var.create && var.create_repository && var.create_repository_policy ? 1 : 0

  dynamic "statement" {
    for_each = var.repository_type == "public" ? [1] : []

    content {
      sid = "PublicReadOnly"

      principals {
        type = "AWS"
        identifiers = coalescelist(
          var.repository_read_access_arns,
          ["*"],
        )
      }

      actions = [
        "ecr-public:BatchGetImage",
        "ecr-public:GetDownloadUrlForLayer",
      ]
    }
  }

  dynamic "statement" {
    for_each = var.repository_type == "private" ? [1] : []

    content {
      sid = "PrivateReadOnly"

      principals {
        type = "AWS"
        identifiers = coalescelist(
          concat(var.repository_read_access_arns, var.repository_read_write_access_arns),
          ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"],
        )
      }

      actions = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:DescribeImageScanFindings",
        "ecr:DescribeImages",
        "ecr:DescribeRepositories",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetLifecyclePolicy",
        "ecr:GetLifecyclePolicyPreview",
        "ecr:GetRepositoryPolicy",
        "ecr:ListImages",
        "ecr:ListTagsForResource",
      ]
    }
  }

  dynamic "statement" {
    for_each = var.repository_type == "private" && length(var.repository_lambda_read_access_arns) > 0 ? [1] : []

    content {
      sid = "PrivateLambdaReadOnly"

      principals {
        type        = "Service"
        identifiers = ["lambda.amazonaws.com"]
      }

      actions = [
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer",
      ]

      condition {
        test     = "StringLike"
        variable = "aws:sourceArn"

        values = var.repository_lambda_read_access_arns
      }

    }
  }

  dynamic "statement" {
    for_each = length(var.repository_read_write_access_arns) > 0 && var.repository_type == "private" ? [var.repository_read_write_access_arns] : []

    content {
      sid = "ReadWrite"

      principals {
        type        = "AWS"
        identifiers = statement.value
      }

      actions = [
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
      ]
    }
  }

  dynamic "statement" {
    for_each = length(var.repository_read_write_access_arns) > 0 && var.repository_type == "public" ? [var.repository_read_write_access_arns] : []

    content {
      sid = "ReadWrite"

      principals {
        type        = "AWS"
        identifiers = statement.value
      }

      actions = [
        "ecr-public:BatchCheckLayerAvailability",
        "ecr-public:CompleteLayerUpload",
        "ecr-public:InitiateLayerUpload",
        "ecr-public:PutImage",
        "ecr-public:UploadLayerPart",
      ]
    }
  }

  dynamic "statement" {
    for_each = var.repository_policy_statements

    content {
      sid           = try(statement.value.sid, null)
      actions       = try(statement.value.actions, null)
      not_actions   = try(statement.value.not_actions, null)
      effect        = try(statement.value.effect, null)
      resources     = try(statement.value.resources, null)
      not_resources = try(statement.value.not_resources, null)

      dynamic "principals" {
        for_each = try(statement.value.principals, [])

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = try(statement.value.not_principals, [])

        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = try(statement.value.conditions, [])

        content {
          test     = condition.value.test
          values   = condition.value.values
          variable = condition.value.variable
        }
      }
    }
  }
}

################################################################################
# Repository
################################################################################

module "aws_ecr_repository" {
  source                          = "git::https://github.com/Quick-Iac/ceq_tf_template_aws_private_ecr?ref=0fbbc8d"
  create                          = var.create
  repository_type                 = var.repository_type
  repository_name                 = var.repository_name
  repository_image_tag_mutability = var.repository_image_tag_mutability


  repository_encryption_type = var.repository_encryption_type
  repository_kms_key         = var.repository_kms_key


  repository_force_delete = var.repository_force_delete


  repository_image_scan_on_push = var.repository_image_scan_on_push
  repository_policy             = var.create_repository_policy ? data.aws_iam_policy_document.repository[0].json : var.repository_policy
  repository_lifecycle_policy   = var.repository_lifecycle_policy

  tags = var.tags
}

################################################################################
# Public Repository
################################################################################

module "aws_ecrpublic_repository" {
  source          = "git::https://github.com/Quick-Iac/ceq_tf_template_aws_public_ecr?ref=7776a38"
  create          = var.create
  repository_type = var.repository_type
  repository_name = var.repository_name

  public_repository_catalog_data = var.public_repository_catalog_data
  repository_policy              = var.create_repository_policy ? data.aws_iam_policy_document.repository[0].json : var.repository_policy
  repository_lifecycle_policy    = var.repository_lifecycle_policy
  tags                           = var.tags
}


