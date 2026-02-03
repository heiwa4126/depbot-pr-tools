#!/usr/bin/env bash
# test7.sh:
# 自分の全リポジトリをスキャンして、
# Dependency Graph が disable になっていて、
# なおかつアーカイブになっていないものを列挙するスクリプト
#
# 依存: gh (GitHub CLI), jq

set -euo pipefail

echo "リポジトリをスキャン中..."

# 自分のリポジトリを全て取得（アーカイブ状態とDependency Graph設定を含む）
gh api graphql --paginate -f query='
  query($endCursor: String) {
    viewer {
      repositories(first: 100, after: $endCursor) {
        pageInfo {
          hasNextPage
          endCursor
        }
        nodes {
          nameWithOwner
          isArchived
          hasVulnerabilityAlertsEnabled
          url
          updatedAt
        }
      }
    }
  }
' | jq -s '
  [.[] | .data.viewer.repositories.nodes[]]
  | map(select(.isArchived == false and .hasVulnerabilityAlertsEnabled == false))
  | map({
      repository: .nameWithOwner,
      url: .url,
      updatedAt: .updatedAt,
      dependencyGraphEnabled: false
    })
'

echo ""
echo "完了: Dependency Graph が無効で、アーカイブされていないリポジトリを表示しました"
