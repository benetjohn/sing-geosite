#!/usr/bin/env bash

set -Eeuo pipefail

ossutil_dir=~/ossutil
git clone https://github.com/aliyun/ossutil.git --depth=1 "$ossutil_dir"
pushd "$ossutil_dir"
go build
export PATH="$ossutil_dir:$PATH"
popd

ossutil config -e "$OSS_ENDPOINT" -i "$OSS_ACCESS_KEY" -k "$OSS_ACCESS_KEY_SECRET"
ossutil cp ../geosite-category-ads-all.srs "oss://$OSS_BUCKET_NAME"
ossutil cp ../geosite-cn.srs "oss://$OSS_BUCKET_NAME"

curl https://cdn.jsdelivr.net/gh/SagerNet/sing-geoip@rule-set/geoip-cn.srs -LO
curl https://cdn.jsdelivr.net/gh/SagerNet/sing-geoip@rule-set/geoip-jp.srs -LO
curl https://cdn.jsdelivr.net/gh/SagerNet/sing-geoip@rule-set/geoip-us.srs -LO
ossutil cp ../geosite-cn.srs "oss://$OSS_BUCKET_NAME"
ossutil cp ../geosite-jp.srs "oss://$OSS_BUCKET_NAME"
ossutil cp ../geosite-us.srs "oss://$OSS_BUCKET_NAME"
