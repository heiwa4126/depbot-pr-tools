# depbot-pr-tools

自分の GitHub repositories を全部スキャンして、Dependabot の PR を JSON 形式でリストするスクリプト

対象となる PR は:

- Dependabot が生成した PR
- レポジトリがアーカイブでない
- PR がオープンである
- PR がマージナブルである(コンフリクトしない) - test2.sh
- PR がマージナブルでない(コンフリクトする) - test4.sh

最初は実験として bash で書く(gh と jq)。
ちょっと複雑になってきたら TypeScript にしてパッケージングする予定

## 経緯&目的

- Dependabot の PR を放置してたら収集がつかなくなった。いま 200 以上ある
- とりあえずモジュールの更新だけの PR から処理したい
- おそらくレポジトリ中で Dependabot の PR が 1 個なら、あまり考えずに merge していいんじゃないか? という雑な考え
- 上に加えて、PR がたくさんある場合でも、最新の 1 個をとりあえず merge する、でいいみたい。(未実装)

## 作業手順

```sh
./test2.sh > tmp2.json
./test3.sh
# ちょっと待つ
./test4.sh > tmp4.json
./test5.sh
# ちょっと待つ。最初に戻る
```

ひどいけどこれでなんとか。**最後に手動で直さないとダメなものだけが残る** ので手で直す。

## 作成メモ

- `gh search prs` の `--json` オプションには `mergeable` がない
- `gh api graphql -f query=` だとカッコいいのだが、最大 100 件しかクエリできないみたい
  - なので `test2.sh > tmp2.json` は何回か繰り返す
- PR をマージすると、マージ後に dependabot が動いて、PR が増えるケースがあるみたい...
