terraform {
  # Assumes s3 bucket and dynamo DB table already set up
  # See /code/03-basics/aws-backend
  backend "s3" {
    bucket         = "tf-state-8473fiqewbgrfi7"
    key            = "06-organization-and-modules/vpc/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"
  azs  = ["ap-southeast-1a", "ap-southeast-1b"]

  # Subnet CIDRs (6 subnets total: 2 in each AZ)
  public_subnets   = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnets  = ["10.0.10.0/24", "10.0.11.0/24"]
  database_subnets = ["10.0.20.0/24", "10.0.21.0/24"]

  # Enable NAT Gateway so private subnets have internet accessg
  enable_nat_gateway     = true
  single_nat_gateway     = true
  enable_dns_hostnames   = true
  enable_dns_support     = true

  # Map public IPs on public subnet instances
  map_public_ip_on_launch = true

  # Tags
  tags = {
    Environment = "dev"
    Project     = "vpc-setup"
  }
}
