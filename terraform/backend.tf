provider "aws" {
  region = "us-east-1"
}

provider "docker" {}
  backend "s3" {
    bucket = "book-mark--989282"
    region = "us-east-1"
    key    = "terraform.tfstate"
    profile = "joshODU"
  }

