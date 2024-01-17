## 概要
このリポジトリの目的は、TerraformのCI/CDを検証することです

### 実施したいこと
- [ ] PRでTerraformのplanを自動で実行し、自動で追記してくれること
- [ ] PRマージで、Terraformのapplyが実行されること
- [ ] terraform fmtの自動実行
- [ ] terraform validateの自動実行

## GitHubに設定する内容
- Environments
    - development
        - AWS_IAM_ROLE_ARN_PLAN :AWSで`terraform plan`まで実行する際のIAMロールのARNを設定する

## 追加すべき設定
以下は有効にする！
- マージ前にレビューを必須にする
- Approve後にコミットされたら再レビュー
- CIをパスすることを必須にする。今回ならfmtやvalidateが該当

参考：https://kojirooooocks.hatenablog.com/entry/2018/05/11/033152

## IAMロール
`terraform plan`はできて、applyできない権限にする

参考：https://dev.classmethod.jp/articles/terraform-iam-policy-not-apply-but-plan/