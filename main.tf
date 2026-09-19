locals {
  env_config = {
    dev = { ec2_count = 1, s3_count = 1 }
    stg = { ec2_count = 2, s3_count = 2 }
    prd = { ec2_count = 1, s3_count = 2 }
  }
}

module "ec2" {
  source    = "./modules/ec2"
  env       = terraform.workspace
  ec2_count = local.env_config[terraform.workspace].ec2_count
}

module "s3" {
  source   = "./modules/s3"
  env      = terraform.workspace
  s3_count = local.env_config[terraform.workspace].s3_count
}
