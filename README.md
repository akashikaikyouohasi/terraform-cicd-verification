## 概要
このリポジトリの目的は、TerraformのCI/CDを検証することです

# 実運用を考えたドキュメント
## 運用フロー
・変更の場合
1. tfenvのインストール
1. 必要なterraformバージョンのインストール
1. ブランチを作成して、変更をコミット
1. PRを作成すると、以下が自動で実施される
    1. `terraform fmt`を行い、自動でコミット
    1. `terraform validate`を行い、問題があったらエラーとする
    1. `terraform plan`を行い、PRに上記の結果と合わせてコメントを行う
1. 問題がなければレビューを依頼する
    1. レビューの結果変更を追加でコミットした場合、自動で`terraform fmt/validate/plan`を行いPRのコメント内容を更新してくれます
    1. `terraform fmt`で修正されたものをpullせずにcommit/pushするとエラーとなるので、rebaseしてください
1. Approveされたら手元で`terraform apply`を実行して、マージする

・Terraformのバージョンアップ
- 毎週月曜に**Dependabot**でアップデートのPRを作成しています
- 適当に確認してマージする（ここはチェックを自動化したい...）

### 補足
- `terraform apply`はローカルで行う運用です。
    - GitHubはAWSに対してReadonlyの権限しか持たせていないためです

## 各自で必須の設定
- GitHub でレビュワーにアサインされたら通知が来るようにすること
- tfenvをインストールして、Terraformをローカルで実行できること
    - credentialの設定は、SSOがベストだが...

## Terraform lockの更新
Mac(Apple siricon)とLinux(GitHub Actions上のUbuntu)に対応させる必要があるため、以下のコマンドで`.terraform.lock.hcl`を調整する必要があります
```
$ terraform providers lock -platform=linux_amd64 -platform=darwin_arm64
```

## GitHubに設定する内容
### Environments
- development
    - AWS_IAM_ROLE_ARN_PLAN :AWSで`terraform plan`まで実行する際のIAMロールのARNを設定する

### 追加すべき設定
以下は有効にする！
- マージ前にレビューを必須にする
- Approve後にコミットされたら再レビュー
- CIをパスすることを必須にする。今回ならfmtやvalidate、planが該当
- ブランチの自動的削除
    - https://docs.github.com/ja/repositories/configuring-branches-and-merges-in-your-repository/configuring-pull-request-merges/managing-the-automatic-deletion-of-branches

参考：https://kojirooooocks.hatenablog.com/entry/2018/05/11/033152

## 使用するIAMロール
`terraform plan`はできて、applyできない権限にする

参考：https://dev.classmethod.jp/articles/terraform-iam-policy-not-apply-but-plan/

## DynamoDB作成コマンド
名前の`terraform-lock`を作成し、パーティションキーを`LockID`とし、プロビジョンドスループットをオートスケールなしの`1`にする。
```
aws dynamodb create-table \
         --region ap-northeast-1 \
         --table-name terraform-lock \
         --attribute-definitions AttributeName=LockID,AttributeType=S \
         --key-schema AttributeName=LockID,KeyType=HASH \
         --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1
```