#!/bin/bash

DEBUG=True 
#DEBUG=False

host_zones=$(aws route53 list-hosted-zones | jq -r '.HostedZones[].Id')

echo "" > terraform.tf

for zone_id in $host_zones;
do
    echo "=========================================="

    # ドメイン名を取得
    zone_name=$(aws route53 get-hosted-zone --id $zone_id | jq -r '.HostedZone.Name') # -rはダブルクォートを取り除く
    trimmed_zone_name=$(echo $zone_name | sed -e 's/.$//') # 末尾のドットを取り除く
    echo Zone Name: $trimmed_zone_name

    # PrivateZoneはスキップ
    private_zone=$(aws route53 get-hosted-zone --id $zone_id | jq -r '.HostedZone.Config.PrivateZone')
    echo PrivateZone: $private_zone
    if [[ $private_zone == 'true' ]]; then
        echo '===PrivateZone is true. Skip this zone.==='
        continue
    fi

    # zoneIDからIDだけを取得
    # 元は /hostedzone/Z038366XXXXXXX という形式
    zone_id=$(echo $zone_id | sed -e 's/\/hostedzone\///')
    echo Zone ID: $zone_id

    # zoneIDからレコードを取得
    records=$(aws route53 list-resource-record-sets --hosted-zone-id $zone_id | jq -c '.ResourceRecordSets[]' ) # -cはカンマ区切りにしてレコードを1行にする
    printf "Records: \n$records\n"

    # forでrecordsを回すと、jqで取得したレコードが改行区切りで取得できるのだが、}が含まれるレコードがあると、}が区切り文字として認識されてしまう
    # そのため、whileで回すことにした
    echo "$records" | while read -r record ; #-rはバックスラッシュをエスケープしない
    do
        echo "========"
        if $DEBUG; then
            echo $record
        fi

        # Nameを取得
        name=$(echo $record | jq -r '.Name' | sed -e 's/.$//') # .NameでNameがキーの値を取得して、末尾のドットを取り除く
        echo $name
        name_without_dot=$(echo $name | sed -e 's/\./_/g') # ドットをアンダースコアに置換
        name_without_hyphen=$(echo $name_without_dot | sed -e 's/-/_/g') # ハイフンをアンダースコアに置換

        # Typeを取得
        type=$(echo $record | jq -r '.Type')
        echo $type

        echo ${name}_${type}

        echo "import {" >> terraform.tf
        echo "  to = aws_route53_record.${name_without_hyphen}_${type}" >> terraform.tf
        echo "  id = \"${zone_id}_${name}_${type}"\" >> terraform.tf
        echo "}" >> terraform.tf
        echo "" >> terraform.tf
    done
done

terraform plan -generate-config-out=generated.tf

