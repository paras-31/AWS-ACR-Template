# Elastic container registry

Configuration in this directory creates Elastic container registry with its lifecycle to store Images.

## Usage

To run this example you need to execute:

```bash
# Terraform Plan/Apply Pipeline

This GitHub Actions workflow automates the Terraform plan and apply process for infrastructure provisioning and management in AWS.

## Workflow Overview

This workflow consists of two main jobs:

1. **terraform-plan**: This job checks out the repository, sets up Terraform, initializes Terraform, runs a Terraform plan, converts the plan to JSON format, uploads the JSON plan to artifacts, and runs Infracost for cost estimation.

2. **terraform-apply**: This job is dependent on the `terraform-plan` job. It checks out the repository, configures AWS credentials, sets up Terraform, initializes Terraform, and applies the Terraform changes.

## Environment Variables

- `REGION`: The AWS region where the infrastructure will be provisioned.

## Secrets

- `AWS_ACCESS_KEY_ID`: Access key for AWS IAM user with permissions to manage infrastructure.
- `AWS_SECRET_ACCESS_KEY`: Secret key for AWS IAM user.
- `CEQ_GHREPOSVCUSER_PAT_TOKEN`: Personal access token for accessing the repository.
- `API_TOKEN`: API_TOKEN for Trend Vision Micro to estimate potential security issues or configurations.
-  To get an API Token from Trend Vision One, follow these steps:
    Log in to Trend Vision One: Go to the Trend Vision One console and log in with your credentials.
    Navigate to API Management: Once logged in, go to the "Administration" or "Settings" section. Look for "API Management" or a similar option.
    Create a New API Key: In the API Management section, there should be an option to create a new API key. Click on it.
    Configure API Key Settings: You may need to specify details such as the name of the API key, permissions, and scope. Configure these settings according to
    your needs.
    Generate the API Key: After configuring the settings, click on the "Generate" or "Create" button to generate the API key.
    Save the API Key: Once generated, the API key will be displayed. Make sure to copy and save it securely as you may not be able to view it again later

## Usage

1. Fork this repository.
2. Set up the required secrets in your repository settings.
3. Modify the workflow file as needed for your specific infrastructure and requirements.
4. Commit and push your changes to trigger the workflow.
5. Monitor the workflow execution and review the Terraform plan before applying changes.


```

Note that this example may create resources which can cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name                                                                     | Version |
| ------------------------------------------------------------------------ | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement_terraform) | >= 1.0  |
| <a name="requirement_aws"></a> [aws](#requirement_aws)                   | >= 4.66 |

## Providers

| Name                                             | Version |
| ------------------------------------------------ | ------- |
| <a name="provider_aws"></a> [aws](#provider_aws) | >= 4.66 |

## Modules

| Name                                                              | Source                                                             | Version |
| ----------------------------------------------------------------- | ------------------------------------------------------------------ | ------- |
| <a name="AWS Private ECR"></a> [Private ECR](#module_Private_ECR) | https://github.com/cloudeq-EMU-ORG/ceq_tf_template_aws_private_ecr | n/a     |
| <a name="module_Public_ECR"></a> [Public_ECR](#module_Public_ECR) | https://github.com/cloudeq-EMU-ORG/ceq_tf_template_aws_public_ecr  | n/a     |

## Resources

| Name                        | Type     |
| --------------------------- | -------- |
| aws_aws_ecr_repository | resource |
| aws_ecr_repository_policy   | resource |
| aws_ecr_lifecycle_policy    | resource |

## Inputs

| Name                               | Description                                                                                                             |
| ---------------------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| create                             | Determines whether resources will be created (affects all resources)                                                    |
| region                             | The AWS region where the ECR will be created                                                                            |
| create_repository                  | Determines whether a repository will be created                                                                         |
| repository_name                    | The name of the repository                                                                                              |
| repository_type                    | The type of repository to create. Either public or private                                                              |
| repository_encryption_type         | The encryption type for the repository. Must be one of: `KMS` or `AES256`. Defaults to `AES256`                         |
| repository_kms_key                 | The ARN of the KMS key to use when encryption_type is `KMS`. If not specified, uses the default AWS managed key for ECR |
| repository_image_scan_on_push      | Indicates whether images are scanned after being pushed to the repository (`true`) or not scanned (`false`)             |
| repository_policy                  | The JSON policy to apply to the repository. If not specified, uses the default policy                                   |
| repository_force_delete            | If `true`, will delete the repository even if it contains images. Defaults to `false`                                   |
| attach_repository_policy           | Determines whether a repository policy will be attached to the repository                                               |
| create_repository_policy           | Determines whether a repository policy will be created                                                                  |
| repository_read_access_arns        | The ARNs of the IAM users/roles that have read access to the repository                                                 |
| repository_lambda_read_access_arns | The ARNs of the Lambda service roles that have read access to the repository                                            |
| repository_read_write_access_arns  | The ARNs of the IAM users/roles that have read/write access to the repository                                           |
| repository_policy_statements       | A map of IAM policy for custom permission usage                                                                         |
| create_lifecycle_policy            | Determines whether a lifecycle policy will be created                                                                   |
| repository_lifecycle_policy        | The policy document. This is a JSON formatted string.                                                                   |
| public_repository_catalog_data     | Catalog data configuration for the repository                                                                           |
| repository_image_tag_mutability    | The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. Defaults to IMMUTABLE              |

