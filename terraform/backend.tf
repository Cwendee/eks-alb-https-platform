terraform {
  backend "s3" {
    bucket         = "pruddie-terraform-remote-state"
    key            = "eks/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
