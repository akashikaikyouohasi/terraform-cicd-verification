## 要件
- route53のレコードを読み込み、terraformインポートをする

## Terraform
リソース名：レコード名_Type

```
import {
  to = aws_route53_record.myrecord
  id = "Z4KAPRWWNC7JR_dev.example.com_NS"
}
```

## メモ
route53のTerraformドキュメント
- Resource: aws_route53_record: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record
- Resource: aws_route53_zone: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone

Terraformのimport参考
- https://dev.classmethod.jp/articles/terraform-v1-5-0-import-and-check-sample/

## 使い方
```
terraform init
./run.sh
terraform plan -generate-config-out=generated.tf

./post_run.sh
terraform plan
 →エラーを修正する
```
