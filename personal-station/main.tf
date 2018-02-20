provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "terraform-mleger"
    key    = "personal-station"
    region = "us-west-2"
  }
}

module "resources" {
  source      = "../resources"
  environment = "personal-station"
  script-path = "init.sh"
}
