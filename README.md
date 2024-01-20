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

## 参考
https://zenn.dev/ykiu/articles/b0ff728f8c52c1