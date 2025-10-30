terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.9.0"

  backend "s3" {
    bucket  = "demo-staging-tfstates"
    key     = "ami.tfstate"
    region  = "eu-south-1"
    encrypt = true
  }
}

provider "aws" {
  region = "eu-south-1"

  default_tags {
    tags = {
      ENV  = "staging"
      Name = "demo"
    }
  }
}

module "demo" {
  source        = "../../infra"
  name          = "demo"
  env           = "staging"
  source_ami_id = "xxx"
  instance_type = "t2.micro"
  key_name      = "ssh_key"
}
