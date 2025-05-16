terraform {
  # Assumes s3 bucket and dynamo DB table already set up
  # See /code/03-basics/aws-backend
  backend "s3" {
    bucket         = "tf-state-8473fiqewbgrfi7"
    key            = "06-organization-and-modules/web-app/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

variable "region" {
  description = "region"
  type        = string
  default     = "ap-southeast-1"
}

variable "db_pass_1" {
  description = "password for database #1"
  type        = string
  sensitive   = true
}

variable "db_pass_2" {
  description = "password for database #2"
  type        = string
  sensitive   = true
}

module "web_app_1" {
  source = "../web-app-module"

  # Input Variables
  bucket_prefix    = "web-app-1-data"
  app_name         = "web-app-1"
  environment_name = "production"
  instance_type    = "t2.micro"
  db_pass          = var.db_pass_1
}

module "web_app_2" {
  source = "../web-app-module"

  # Input Variables
  bucket_prefix    = "web-app-2-data"
  app_name         = "web-app-2"
  environment_name = "production"
  instance_type    = "t2.micro"
  db_pass          = var.db_pass_2

}

output "web_app_1_instance_1_ip_addr" {
  value = module.web_app_1.instance_1_ip_addr
}

output "web_app_1_instance_2_ip_addr" {
  value = module.web_app_1.instance_2_ip_addr
}

output "web_app_2_instance_1_ip_addr" {
  value = module.web_app_2.instance_1_ip_addr
}

output "web_app_2_instance_2_ip_addr" {
  value = module.web_app_2.instance_2_ip_addr
}

output "web_app_1_lb_dns" {
  value = module.web_app_1.load_balancer_dns
}

output "web_app_2_lb_dns" {
  value = module.web_app_2.load_balancer_dns
}