#!/usr/bin/env bash
set -Eeuo pipefail

# Configure AWS CLI for R2
mkdir -p ~/.aws
cat > ~/.aws/credentials << EOF
[default]
aws_access_key_id=${R2_ACCESS_KEY_ID}
aws_secret_access_key=${R2_ACCESS_KEY_SECRET}
EOF

aws_cli_cp_args="--endpoint-url https://${CLOUDFLARE_ACCOUNT_ID}.r2.cloudflarestorage.com --checksum-algorithm CRC32 --force"

# Upload locally built files
# shellcheck disable=SC2086
aws s3 cp rule-set/geosite-category-ads-all.srs "s3://${R2_BUCKET_NAME}/" \
  $aws_cli_cp_args

# shellcheck disable=SC2086
aws s3 cp rule-set/geosite-cn.srs "s3://${R2_BUCKET_NAME}/" \
  $aws_cli_cp_args

# Download and upload external files
curl --fail https://raw.githubusercontent.com/SagerNet/sing-geoip/rule-set/geoip-cn.srs -LO
curl --fail https://raw.githubusercontent.com/SagerNet/sing-geoip/rule-set/geoip-jp.srs -LO
curl --fail https://raw.githubusercontent.com/SagerNet/sing-geoip/rule-set/geoip-us.srs -LO

# Upload downloaded files to R2
for file in geoip-{cn,jp,us}.srs; do
  # shellcheck disable=SC2086
  aws s3 cp "$file" "s3://${R2_BUCKET_NAME}/" \
    $aws_cli_cp_args
done
