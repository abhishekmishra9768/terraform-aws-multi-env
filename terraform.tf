terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.64.0"
    }
  }

  backend "s3" {
    bucket       = "terraform-aws-multi-env-remote-backend-2026"
    key          = "terraform-aws-multi-env/terraform.tfstate"
    region       = "ap-south-1"
    use_lockfile = true
  }
}
