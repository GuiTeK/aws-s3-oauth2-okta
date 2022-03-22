provider "aws" {
  region              = "eu-west-1"
  allowed_account_ids = [var.aws_account_id]
}

provider "aws" {
  region              = "us-east-1"
  allowed_account_ids = [var.aws_account_id]

  alias = "us-east-1"
}
