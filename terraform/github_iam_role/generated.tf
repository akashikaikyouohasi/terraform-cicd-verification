# __generated__ by Terraform
# Please review these resources and move them into your main configuration files.

# __generated__ by Terraform from "GitHubActionsTerraformPlan"
resource "aws_iam_role" "developer" {
  assume_role_policy    = "{\"Statement\":[{\"Action\":\"sts:AssumeRoleWithWebIdentity\",\"Condition\":{\"StringEquals\":{\"token.actions.githubusercontent.com:aud\":\"sts.amazonaws.com\"},\"StringLike\":{\"token.actions.githubusercontent.com:sub\":\"repo:akashikaikyouohasi/terraform-cicd-verification:*\"}},\"Effect\":\"Allow\",\"Principal\":{\"Federated\":\"arn:aws:iam::206863353204:oidc-provider/token.actions.githubusercontent.com\"}}],\"Version\":\"2012-10-17\"}"
  description           = null
  force_detach_policies = false
  managed_policy_arns   = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  max_session_duration  = 3600
  name                  = "GitHubActionsTerraformPlan"
  name_prefix           = null
  path                  = "/"
  permissions_boundary  = null
  tags                  = {}
  tags_all              = {}
  inline_policy {
    name   = "allowUpdateStateLockDdb"
    policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"dynamodb:GetItem\",\"dynamodb:PutItem\",\"dynamodb:DeleteItem\"],\"Effect\":\"Allow\",\"Resource\":\"*\"}]}"
  }
}
