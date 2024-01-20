terraform {
  # terraformのバージョン指定
  required_version = ">=1.6"

  # 使用するAWSプロバイダーのバージョン指定（結構更新が速い）
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.32.0"
    }
  }

  # tfstate(状態管理用ファイル)をS3に保存する設定
  backend "s3" {
    bucket         = "tfstate-terraform-20211204"
    key            = "terraform-cicd/ecr.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "terraform-lock"
  }
}

# 明示的にAWSプロバイダを定義（暗黙的に理解してくれる）
provider "aws" {
  region = "ap-northeast-1"
}

# グローバルリージョンにデプロイする必要があるもの用：Multiple Providers機能
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}
