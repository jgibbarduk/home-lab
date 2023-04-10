
module "remote_state" {
  source = "nozaq/remote-state-s3-backend/aws"
  override_s3_bucket_name = true
  s3_bucket_name          = "terraform-state-dingous-home-lab"

  enable_replication = false
  dynamodb_enable_server_side_encryption = true

  providers = {
    aws         = aws
    aws.replica = aws.replica
  }
}

resource "aws_iam_user" "terraform" {
  name = "TerraformUser"
}

resource "aws_iam_user_policy_attachment" "remote_state_access" {
  user       = aws_iam_user.terraform.name
  policy_arn = module.remote_state.terraform_iam_policy.arn
}