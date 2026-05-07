provider "aws" {
  region = "ap-southeast-1"
}

terraform {
  backend "s3" {
    bucket = "sctp-ce12-tfstate-bucket"
    key    = "nas-s3buckets.tfstate"
    region = "ap-southeast-1"
  }
}

resource "aws_s3_bucket" "s3_tf" {
  bucket_prefix = "nas-s3buckets"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.44.0"
    }
  }
}

terraform {
  required_version = ">= 1.5.0, < 2.0.0"
}

resource "aws_s3_bucket" "s3_tf" {
  #checkov:skip=CKV2_AWS_61
  #checkov:skip=CKV_AWS_144
  #checkov:skip=CKV_AWS_21
  #checkov:skip=CKV_AWS_18
  #checkov:skip=CKV_AWS_145
  bucket_prefix = "nas-s3buckets"
}