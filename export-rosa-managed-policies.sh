#!/bin/bash

# ROSA で始まる AWS 管理ポリシーのリストを取得
policy_list=$(aws iam list-policies \
  --scope AWS \
  --query "Policies[?starts_with(PolicyName, 'ROSA')].[PolicyName, Arn, DefaultVersionId]" \
  --output json)

# jq がインストールされていることを確認
if ! command -v jq &> /dev/null; then
    echo "jq が必要です。インストールしてください。"
    exit 1
fi

# 各ポリシーについてループ
echo "$policy_list" | jq -c '.[]' | while read -r policy; do
    name=$(echo "$policy" | jq -r '.[0]')
    arn=$(echo "$policy" | jq -r '.[1]')
    version=$(echo "$policy" | jq -r '.[2]')

    echo "Downloading policy: $name"

    aws iam get-policy-version \
      --policy-arn "$arn" \
      --version-id "$version" \
      --query "PolicyVersion.Document" \
      --output json > "${name}.json"
done

echo "✅ 完了！ROSA ポリシーはすべて保存されました。"
