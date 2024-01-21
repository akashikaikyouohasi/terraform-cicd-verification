# アカウントID取得
data "aws_caller_identity" "current" {}

# GitHub ActionsからのIAMロールへのアクセスを許可するIAMロールを作成
resource "aws_iam_role" "github_actions_terraform_plan" {
    name                  = "GitHubActionsTerraformPlan"
  assume_role_policy = data.aws_iam_policy_document.github_actions_terraform_plan_assume_role_policy.json
  managed_policy_arns   = [
        "arn:aws:iam::aws:policy/ReadOnlyAccess"
    ]
  inline_policy {
    name   = "allowUpdateStateLockDdb"
    policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Action\":[\"dynamodb:GetItem\",\"dynamodb:PutItem\",\"dynamodb:DeleteItem\"],\"Effect\":\"Allow\",\"Resource\":\"*\"}]}"
  }
}
data "aws_iam_policy_document" "github_actions_terraform_plan_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:akashikaikyouohasi/terraform-cicd-verification:*"]
    }
  }
}

# ReadOnlyAccessポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "ReadOnlyAccess" {
  role       = aws_iam_role.github_actions_terraform_plan.name
  policy_arn = data.aws_iam_policy.ReadOnlyAccess.arn
}
data "aws_iam_policy" "ReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# DynamoDBのテーブルに対するアクセス権限を付与
resource "aws_iam_role_policy_attachment" "allowUpdateStateLockDdb" {
  role       = aws_iam_role.github_actions_terraform_plan.name
  policy_arn = aws_iam_policy.allowUpdateStateLockDdb.arn
}
resource "aws_iam_policy" "allowUpdateStateLockDdb" {
  name        = "allowUpdateStateLockDdb"
  description = "allowUpdateStateLockDdb"
  policy      = data.aws_iam_policy_document.allowUpdateStateLockDdb.json
}
data "aws_iam_policy_document" "allowUpdateStateLockDdb" {
  statement {
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}
