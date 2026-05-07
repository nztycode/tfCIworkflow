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

# Block public access
resource "aws_s3_bucket_public_access_block" "s3_tf_block" {
  bucket                  = aws_s3_bucket.s3_tf.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning
resource "aws_s3_bucket_versioning" "s3_tf_versioning" {
  bucket = aws_s3_bucket.s3_tf.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Default encryption with AWS-managed KMS
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_tf_encryption" {
  bucket = aws_s3_bucket.s3_tf.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

# Lifecycle configuration (simple example: expire objects after 365 days)
resource "aws_s3_bucket_lifecycle_configuration" "s3_tf_lifecycle" {
  bucket = aws_s3_bucket.s3_tf.id

  rule {
    id     = "expire-old-objects"
    status = "Enabled"

    expiration {
      days = 365
    }
  }
}

# Logging (requires a separate bucket for logs)
resource "aws_s3_bucket" "log_bucket" {
  bucket = "nas-s3buckets-logs"
}

resource "aws_s3_bucket_logging" "s3_tf_logging" {
  bucket        = aws_s3_bucket.s3_tf.id
  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "logs/"
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

