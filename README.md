NB: Was not tested to create actual resources
Tested only via
[tflint](https://github.com/terraform-linters/tflint)
[terraform fmt -recursive](https://developer.hashicorp.com/terraform/cli/commands/fmt)
[checkov -d ./](https://www.checkov.io/)

1. aws configure
2. terraform init
3. terraform plan -out=tfplan
4. terraform apply "tfplan"