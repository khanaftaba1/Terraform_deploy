terraform {
  backend "s3" {
    bucket = "env-aftabsbigbukcet"
    key    = "webserver/terraform.tfstate"
    region = "us-east-1"
}
}
