##################
# S3 State File          # "terraform init" with either the "-reconfigure" or "-migrate-state"
##################

# terraform {
#   backend "s3" {
#     encrypt = true
#     bucket  = ""
#     # dynamodb_table       = "terraform-state-lock-dynamo"
#     key                  = "terraform.tfstate"
#     region               = "eu-north-1"
#     workspace_key_prefix = "workspaces"
#   }
# }

# resource "aws_dynamodb_table" "dynamodb_terraform_state_lock" {
#   name           = "terraform-state-lock-dynamo"
#   hash_key       = "LockID"
#   read_capacity  = 20
#   write_capacity = 20

#   attribute {
#     name = "LockID"
#     type = "S"
#   }
# }
