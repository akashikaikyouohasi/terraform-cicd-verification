## 概要
このリポジトリの目的は、TerraformのCI/CDを検証することです

### 実施したいこと
- [x] PRでTerraformのplanを自動で実行し、自動で追記してくれること
- [ ] PRマージで、Terraformのapplyが実行されること
- [x] terraform fmtの自動実行
- [x] terraform validateの自動実行
- [x] PRのテンプレート作成
- [x] DynamoDBロックの作成
-  ~~profile設定~~
    - CIで面倒なので一旦なし
- [ ] GitHub actionsのIAMロールのimport
- [ ] DependBotの設定
    - Dependabot alerts:
    - Dependabot security updates:
    - Grouped security updates Beta:
    - Dependabot version updates:
- ~~working-directoryを調整~~
    - compositeでは継承されなさそう
- [x] matrixの調整
- [ ] PR検証
    - 後からディレクトリを追加していって認識するか
- [x] 同時実行数1にしたい
- [x] PRのコメントを更新にする
    - 一度に複数回コメントを行う可能性があるので、更新できない？→working-directoryを追記するようにしたからできたわ！
    - 文字列を追加してできそう？
- [x] tfenvでのterraformバージョン指定
    - `.terraform-version`ファイルを追加することで、そのバージョンを利用するようになる
    - 参考：https://github.com/tfutils/tfenv?tab=readme-ov-file#terraform-version-file
- [ ] `terraform.lcck.hcl`設定
- [ ] `terraform validate`で確認できることを把握する

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

## 確認したいこと
GitHub Actionsのローカル検証
```
%brew install act
% act -l --container-architecture linux/amd64
Stage  Job ID                             Job name                           Workflow name                Workflow file       Events
0      create_changed_directory_list      create_changed_directory_list      terraform fmt/validate/plan  terraform_plan.yml  pull_request
0      terraform                          terraform                          terraform fmt/validate/plan  terraform_plan.yml  pull_request
1      run_tasks_for_changed_directories  run_tasks_for_changed_directories  terraform fmt/validate/plan  terraform_plan.yml  pull_request
%  act pull_request
```
ちゃんと動作確認はできていない...

## 必須の設定
- GitHub でレビュワーにアサインされたら通知が来るようにすること
- tfenvをインストールして、Terraformをローカルで実行できること
    - credentialの設定は、SSOがベストだが...

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
1. Approveされたら手元で`terraform apply`を実行して、マージする

・Terraformのバージョンアップ
- 毎週月曜に**Dependabot**でアップデートのPRを作成しています
- 適当に確認してマージする（ここはチェックを自動化したい...）

### 補足
- `terraform apply`はローカルで行う運用です。
    - GitHubはAWSに対してReadonlyの権限しか持たせていないためです

## 参考
https://zenn.dev/ykiu/articles/b0ff728f8c52c1