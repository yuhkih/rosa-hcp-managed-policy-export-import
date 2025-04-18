#!/bin/bash

# ポリシーファイルが入っているディレクトリ
POLICY_DIR="./"  # ← 適宜変更

# AWS アカウント ID の取得（後で確認用）
ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)

# ディレクトリ内のすべての .json ファイルを処理
for file in "$POLICY_DIR"/*.json; do
  # ファイル名から拡張子を除いてポリシー名に使う
  filename=$(basename -- "$file")
  policy_name="MY_${filename%.*}"

  echo "🛠 Creating policy: $policy_name from $file"

  # IAM Policy を作成
  aws iam create-policy \
    --policy-name "$policy_name" \
    --policy-document file://"$file" \
    --description "Imported from $filename on $(date '+%Y-%m-%d')" \
    --tags Key=CreatedBy,Value=Script Key=Source,Value=BulkImport \
    --output text || echo "⚠️  Skipped or failed: $policy_name"
done

echo "✅ 完了しました。IAM ポリシーが作成されました。"

