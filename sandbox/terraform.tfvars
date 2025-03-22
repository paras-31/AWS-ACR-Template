create = true
region = "eu-west-1"
tags = {
  PROJECT_NAME     = "AWS WAFR"
  DEPARTMENT_NAME  = "AWS DEVOPS"
  APPLICATION_NAME = "AWS-ECR"
  CLIENT_NAME      = "CEQ-INTERNAL"
  OWNER_NAME       = "template@cloudeq.com"
  SOW_NUMBER       = "CEQSOW24084OV"
}
repository_type                   = "private"
create_repository                 = true
repository_name                   = "aws_wafr_ecr"
repository_image_scan_on_push     = true
repository_force_delete           = true
create_repository_policy          = true
repository_read_access_arns       = ["arn:aws:iam::533267235239:user/aws_Wafr_user"]
repository_read_write_access_arns = ["arn:aws:iam::533267235239:user/aws_Wafr_user"]
create_lifecycle_policy = true
public_repository_catalog_data = {
  about_text        = "This repository contains sample catalog data for various applications."
  architectures     = ["x86", "arm"]
  description       = "A sample repository for demonstrating catalog data configuration."
#   logo_image_blob   = "base64encodedimagestring"
  operating_systems = ["linux", "windows"]
  usage_text        = "To use this repository, clone it and follow the instructions in the README."
}



repository_lifecycle_policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Expire images older than 30 days",
      "selection": {
        "tagStatus": "untagged",
        "countType": "sinceImagePushed",
        "countUnit": "days",
        "countNumber": 30
      },
      "action": {
        "type": "expire"
      }
    },
    {
      "rulePriority": 2,
      "description": "Retain only the last 10 images tagged with 'release'",
      "selection": {
        "tagStatus": "tagged",
        "tagPrefixList": ["release"],
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
