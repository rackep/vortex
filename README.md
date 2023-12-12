# vortex
Vortex terraform project


# Terraform commands

terraform init

# aws 4.67.0 does not match configured version constraint >= 5.0.0
terraform init -upgrade

terraform plan


terraform apply -var-file="testing.tfvars"

    Environment variables
    The terraform.tfvars file, if present.
    The terraform.tfvars.json file, if present.
    Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.
    Any -var and -var-file options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace.)