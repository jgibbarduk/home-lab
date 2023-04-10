terraform {
  backend "s3" {
    bucket         = "terraform-state-dingous-home-lab"
    key            = "terraform-nomad/terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    kms_key_id     = "13736b33-04f3-498e-8498-3f574e9c259c"
    dynamodb_table = "tf-remote-state-lock"
  }
}