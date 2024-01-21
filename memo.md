
### 実施したいこと
- [x] PRでTerraformのplanを自動で実行し、自動で追記してくれること
- ~~PRマージで、Terraformのapplyが実行されること~~
    - applyは一旦しない
- [x] terraform fmtの自動実行
- [x] terraform validateの自動実行
- [x] PRのテンプレート作成
- [x] DynamoDBロックの作成
-  ~~profile設定~~
    - CIで面倒なので一旦なし
- [x] GitHub actionsのIAMロールのimport
- [x] Dependabotの設定
    - [x] 機能確認
        - Dependabot alerts:脆弱性が検知とアラート
        - Dependabot security updates:検知された脆弱性に対するPR自動作成
        - Grouped security updates Beta:自動作成されるPRを1つにまとめる！
            - あまりに数が多いなら設定してもいいかも。まだBetaなので。
        - Dependabot version updates:`dependabot.yml`で設定したコードの、依存関係を最新状態に保つPRを自動で作成
        - group以外を有効で良さそう！
- [x] RenovateとDependabotの違いは？
    - DependabotはGitHub所有、RenovateはMend社が開発。Renovateの方が色々機能があるっぽい
- ~~working-directoryを調整~~
    - composite actionでは継承されなさそう
- [x] matrixの調整
- [x] PR検証
    - [x] 後からディレクトリを追加していって認識するか
    - [x] fmtでの修正が複数で必要な場合に、1度のコミットで修正されているか
    - [x] ディレクトリごとのPlan結果がコメントされるか
    - [x] ディレクトリごとのPlan結果がコメントが、追加コミットで更新されるか（新しいコメントにならないかということ）
- [x] 同時実行数1にしたい
- [x] PRのコメントを更新にする
    - 一度に複数回コメントを行う可能性があるので、更新できない？→working-directoryを追記するようにしたからできたわ！
    - 文字列を追加してできそう？
- [x] tfenvでのterraformバージョン指定
    - `.terraform-version`ファイルを追加することで、そのバージョンを利用するようになる
    - 参考：https://github.com/tfutils/tfenv?tab=readme-ov-file#terraform-version-file
- [x] `terraform.lcck.hcl`設定
- [x] workflow内でのTerraformバージン自動設定
- [x] `terraform validate`で確認できることを把握する
    - 属性名や値の型の正確性など、再利用可能なモジュールの一般的な検証に役立つとのこと
- [x] fmtを一度だけ実行するようにする。今は、サブディレクトリでやっているけど、ムダだよね。
-  ~~Terraformのテストいる？~~
    - 現時点ではいいかな。Terraform自体が宣言的だから、書いてある状態になるので。


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
GitHub Actions で差分有無に応じた細かい制御を行う
https://zenn.dev/ykiu/articles/b0ff728f8c52c1

dependabot
https://qiita.com/yokawasa/items/38c6a4242cbe0fd5bbf0
https://zenn.dev/dzeyelid/articles/e36d439cdeda5edb7ddc

Dependabot group
https://zenn.dev/yuki0920/articles/9af3a7581193bf

terraform providers lock
https://dev.classmethod.jp/articles/multiplatform-terraform-init-lock/

`terraform plan -generate-config-out=generated.tf`でimport
https://dev.classmethod.jp/articles/terraform-v1-5-0-import-and-check-sample/

---