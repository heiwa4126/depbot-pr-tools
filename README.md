# depbot-pr-tools (working title)

自分の GitHub repositories を全部スキャンして、Dependabot の PR を JSON 形式でリストするスクリプト

対象となるPRは:

- Dependabot が生成した PR
- レポジトリがアーカイブでない
- PR がオープンである
- PR がマージナブルである(コンフリクトしない)

最初は実験として bash で書く(ghとjq)。
ちょっと複雑になってきたら TypeScript にしてパッケージングする予定

## 目的

- Dependabot の PR を放置してたら収集がつかなくなった。いま 200 以上ある
- とりあえずモジュールの更新だけのPRから処理したい。
- おそらく レポジトリ中で Dependabot の PR が 1個なら、あまり考えずに merge していいんじゃないか? という雑な考え

## 作業メモ

- `gh search prs` の `--json` オプションには `mergeable` がない
- `gh api graphql -f query=` だとカッコいいのだが、最大100件しかクエリできないみたい
  - なので `test2.sh > tmp2.json` は何回か繰り返す
- PRをマージすると、マージ後にdependabotが動いて、PRが増えるケースがあるみたい...
