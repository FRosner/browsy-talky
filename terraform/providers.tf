provider "aws" {
  region  = "eu-central-1"
  version = "1.37"
}

data "aws_region" current {}