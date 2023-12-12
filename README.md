# Vortex terraform project

## Prerequisites

### AWS Account
Access key ID & Secret Access Key of that account with user logged in.

### Tools

```bash
$ aws --version
aws-cli/2.13.28 Python/3.11.6 Windows/10 exe/AMD64 prompt/off

$ terraform version
Terraform v1.6.2
on windows_amd64
+ provider registry.terraform.io/hashicorp/aws v5.30.0
```

## Terraform commands

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

## Deploying application

#### Plan specific resource

    terraform plan -target=module.networking.aws_security_group_rule.https_public


#### Plan changes
Supply .tfvars file to plan changes on specific environment

    terraform plan -var-file="./environments/dev/dev.tfvars"

#### Deploy stack
Supply .tfvars file to create a stack on specific environment

    terraform apply -var-file="./environments/dev/dev.tfvars" -auto-approve
    
#### Destroy a stack

Supply .tfvars file to destroy a stack on specific environment

    terraform destroy -var-file="./environments/dev/dev.tfvars" -auto-approve

## Environments

Environment can be changed with `terraform workspaces`

### Working with workspaces 

```bash

# List current workspaces
$ terraform workspace list
* default

# Create dev workspace
$ terraform workspace new dev

# Create prod workspace
$ terraform workspace new prod

# Select a workspace
$ terraform workspace select prod

# List workspaces and see active workspace
$ terraform workspace list
  default
  dev
* prod
```

### Deploy application on specific environment

Use `-var-file` to supply config for specific environment

```bash
# Select a workspace
$ terraform workspace select dev

# Plan changes
$ terraform plan -var-file="./environments/dev/dev.tfvars"

# Deploy stack
$ terraform apply -var-file="./environments/dev/dev.tfvars" -auto-approve

# Destroy stack
$ terraform destroy -var-file="./environments/dev/dev.tfvars" -auto-approve
```

### Remote state file

By default this option is commented out.
Remote state file is published on s3 bucket through `backend.tf`. S3 bucket must be created prior to creating a stack and it's name must be entered into the field.
Different environments state files will be under different path in the s3 bucket.

```txt
bucket_name
└── workspaces/
    ├── dev/
    │   └── terraform.tfstate
    └── prod/
        └── terraform.tfstate
```
