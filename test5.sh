#!/usr/bin/env bash
# test5.sh: tmp4.json のPRを全てクローズするスクリプト
# 依存: gh (GitHub CLI), jq

set -euo pipefail

# tmp4.jsonからリポジトリ名とPR番号を抽出し、ghコマンドでクローズ
jq -r '.[] | .repository as $repo | .prs[] | [$repo, .number] | @tsv' tmp4.json | while IFS=$'\t' read -r repo pr_number; do
  echo "[INFO] Closing PR #$pr_number in $repo"
  gh pr close $pr_number --repo $repo --delete-branch
  # --delete-branch はPRの元ブランチも削除（不要なら外す）
done
