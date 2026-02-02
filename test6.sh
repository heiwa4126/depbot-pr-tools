#!/usr/bin/env bash
# test6.sh:
# https://github.com/notifications にある notificarions のうち
#  * Dependabot から来た PR で
#  * mergeに成功してcloseなもの、またはmerge不能なもの
# に対して done にするスクリプト
#
# 依存: gh (GitHub CLI), jq

set -euo pipefail

echo "Dependabotの通知を処理中..."

# 全ての通知を取得
notifications=$(gh api notifications --paginate)

# 各通知を処理
echo "$notifications" | jq -c '.[]' | while read -r notification; do
  # 通知の詳細を取得
  subject=$(echo "$notification" | jq -r '.subject.title')
  type=$(echo "$notification" | jq -r '.subject.type')
  url=$(echo "$notification" | jq -r '.subject.url')
  thread_id=$(echo "$notification" | jq -r '.id')
  reason=$(echo "$notification" | jq -r '.reason')

  # Pull Requestの通知のみ処理
  if [[ "$type" == "PullRequest" ]]; then
    # PRの詳細を取得
    pr_data=$(gh api "$url")
    user=$(echo "$pr_data" | jq -r '.user.login')
    state=$(echo "$pr_data" | jq -r '.state')
    merged=$(echo "$pr_data" | jq -r '.merged')
    mergeable=$(echo "$pr_data" | jq -r '.mergeable')

    # Dependabotからのもので、条件に合うか確認
    if [[ "$user" == "dependabot[bot]" || "$user" == "dependabot" ]]; then
      should_mark_done=false

      # マージ済みでクローズ
      if [[ "$state" == "closed" && "$merged" == "true" ]]; then
        echo "✓ マージ済み: $subject"
        should_mark_done=true
      # マージ不能
      elif [[ "$mergeable" == "false" ]]; then
        echo "✗ マージ不能: $subject"
        should_mark_done=true
      fi

      # 条件に合う場合、通知をdoneにする
      if [[ "$should_mark_done" == "true" ]]; then
        gh api -X PATCH "notifications/threads/$thread_id" > /dev/null
        echo "  → 通知を完了としてマーク"
      fi
    fi
  fi
done

echo "完了しました"
