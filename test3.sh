#!/bin/bash
# test3.sh: PRが1つだけのリポジトリのPRを列挙し、ghコマンドで実行（例:マージ）する
# 依存: gh (GitHub CLI), jq

set -euo pipefail

# tmp2.jsonからPRが1つだけのリポジトリを抽出し、リポジトリ名とPR番号を取得
jq -r '.[] | select(.prs | length == 1) | [.repository, .prs[0].number] | @tsv' tmp2.json | while IFS=$'\t' read -r repo pr_number; do
  echo "[INFO] repo: $repo, PR: #$pr_number"
  # PRの詳細を表示
  # gh pr view $pr_number --repo $repo
  # 必要に応じて下記のコメントアウトを外してマージ等を実行
  gh pr merge $pr_number --repo $repo --auto --squash
  echo "[INFO] Merged PR #$pr_number in $repo"
done
