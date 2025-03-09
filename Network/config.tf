terraform {
  backend "s3" {
    bucket = "env-aftabsbigbukcet"
    key    = "networking/terraform.tfstate"
    region = "us-east-1"
}
}
