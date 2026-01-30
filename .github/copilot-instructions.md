# Copilot Instructions for depbot-pr-tools Project

## プロジェクト概要

- このリポジトリは、**自分の GitHub リポジトリ全体をスキャンし、Dependabot のPRをJSON形式でリストアップする**ためのスクリプト群です。
- 主な目的は、放置されたDependabot PRの管理・可視化・効率的なマージ判断を支援することです。

## 主要ファイル・構成

- `test1.sh`, `test2.sh`: Bashスクリプト。`gh` CLIと`jq`を使い、GraphQLでDependabot PRを取得し、マージ可能なもののみをJSONで出力。
- `tmp1.json`, `tmp2.json`: スクリプトの出力例や一時保存用ファイル。
- `README.md`: プロジェクトの目的・背景・技術選定理由を記載。

## ワークフロー・使い方

- **依存コマンド**: `gh` (GitHub CLI), `jq` が必要。
- **実行方法**: `bash test1.sh` または `bash test2.sh` で実行。
- **出力**: 各リポジトリごとに、マージ可能なDependabot PRのリストをJSONで出力。
- **GraphQLクエリ**: `mergeable` フィールドでマージ可能なPRのみ抽出。
- **注意点**: `gh search prs` の `--json` には `mergeable` が無いため、GraphQL APIを利用。

## コーディング・拡張方針

- **最初はBashで実装**し、複雑化したらTypeScript化・パッケージ化を検討。
- **PRの条件**: 「オープン」「マージ可能（コンフリクトなし）」のみを対象。
- **ラベルやリポジトリ単位でグルーピング**しやすいようにJSON整形。
- **今後の拡張**: TypeScript化時は、現行Bashスクリプトのロジックを踏襲。

## プロジェクト固有のパターン・注意点

- **GraphQLの1回の取得件数制限**（最大100件）に注意。
- **`labels`の取得数**はスクリプトごとに異なる（`test1.sh`は10件、`test2.sh`は100件）。
- **一時ファイル**（`tmp*.json`）は出力例やデバッグ用。

## 参考ファイル

- 主要なロジックは `test1.sh`, `test2.sh` に集約。
- 詳細な背景や設計意図は `README.md` を参照。

---

AIエージェントは、上記の構成・ワークフロー・設計意図を理解した上で、

- Bashスクリプトの拡張・修正
- TypeScript化の際の設計引き継ぎ
- コマンドや出力形式の一貫性維持
  に留意してください。
