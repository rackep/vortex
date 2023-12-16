# Vortex terraform project

# Prerequisites

# AWS Account
Access key ID & Secret Access Key of that account with user logged in.

# Tools

```bash
$ aws --version
aws-cli/2.13.28 Python/3.11.6 Windows/10 exe/AMD64 prompt/off

$ terraform version
Terraform v1.6.2
on windows_amd64
+ provider registry.terraform.io/hashicorp/aws v5.30.0
```

# Terraform commands

```bash
# Initialize repo
terraform init

# Fix for error bellow
# aws 4.67.0 does not match configured version constraint >= 5.0.0
terraform init -upgrade

# Plan changes
terraform plan
terraform plan -var-file="dev.tfvars" -out=plan

# Apply changes and use custom vars file
terraform apply -var-file="dev.tfvars"
terraform apply plan
```

    Environment variables
    The terraform.tfvars file, if present.
    The terraform.tfvars.json file, if present.
    Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.
    Any -var and -var-file options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace.)


```bash
# Partial plan

# resource
terraform plan -target=module.mymodule.aws_instance.myinstance
terraform apply -target=module.mymodule.aws_instance.myinstance

# module

terraform plan -target=aws_instance.myinstance
terraform apply -target=aws_instance.myinstance
```

terraform plan -target=module.networking.aws_security_group_rule.https_public