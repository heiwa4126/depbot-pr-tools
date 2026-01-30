#!/usr/bin/env bash
# 自分の GitHub repositories を全部スキャンして、
# Dependabot の PR を JSON 形式でリストするスクリプト
# PRはマージ可能でないものだけ抽出する

set -euo pipefail

gh api graphql -f query='
  query {
    search(query: "is:pr is:open author:app/dependabot user:@me archived:false", type: ISSUE, first: 100) {
      nodes {
        ... on PullRequest {
          repository { nameWithOwner }
          number
          title
          url
          updatedAt
          labels(first: 100) { nodes { name } }
          mergeable
        }
      }
    }
  }
' | jq '
  .data.search.nodes
  | map(select(.mergeable != "MERGEABLE"))
  | group_by(.repository.nameWithOwner)
  | map({
      repository: .[0].repository.nameWithOwner,
      prs: map({
        number: .number,
        title: .title,
        url: .url,
        updatedAt: .updatedAt,
        labels: .labels.nodes | map(.name)
      })
    })
'
