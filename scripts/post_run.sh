#!/bin/bash
# gsedはbrew install gnu-sedでインストールしたgsedを使う
gsed -i -e '/allow_overwrite\s*=\s*null/d' generated.tf # allow_overwrite = null という行を削除
gsed -i -e '/health_check_id\s*=\s*=null/d' generated.tf # health_check_id = null という行を削除
gsed -i -e '/multivalue_answer_routing_policy\s*=\s*false/d' generated.tf # multivalue_answer_routing_policy = false という行を削除
gsed -i -e '/set_identifier\s*=\s*null/d' generated.tf # set_identifier = null という行を削除
gsed -i -e '/records\s*=\s*\[\]/d' generated.tf # records = [] という行を削除
gsed -i -e '/ttl\s*=\s*0/d' generated.tf # ttl = 0 という行を削除


terraform plan

#% terraform import aws_route53_record.myrecord Z4KAPRWWNC7JR_dev.example.com_NS

host_zones=$(aws route53 list-hosted-zones | jq -r '.HostedZones[].Id')

for zone_id in $host_zones;
do
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
        # Nameを取得
        name=$(echo $record | jq -r '.Name' | sed -e 's/.$//') # .NameでNameがキーの値を取得して、末尾のドットを取り除く
        echo $name
        name_without_dot=$(echo $name | sed -e 's/\./_/g') # ドットをアンダースコアに置換
        name_without_hyphen=$(echo $name_without_dot | sed -e 's/-/_/g') # ハイフンをアンダースコアに置換

        # Typeを取得
        type=$(echo $record | jq -r '.Type')
        echo $type

        echo ${name}_${type}

        terraform import aws_route53_record.${name_without_hyphen}_${type} ${zone_id}_${name}_${type}
    done
done

