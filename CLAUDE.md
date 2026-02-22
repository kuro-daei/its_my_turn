# CLAUDE.md

このファイルは Claude Code がこのリポジトリで作業する際のガイダンスを提供します。

## プロジェクト概要

「今日から私は。Claude Code 編」— 非エンジニア向けに Claude Code の使い方を解説するドキュメントプロジェクト。

- **目的**: Claude Code の機能・活用法を、技術的な背景がない人にもわかりやすく伝える
- **成果物**: `docs/curriculum/` 以下の Markdown ファイル群
- **対象読者**: 非エンジニア（PM、デザイナー、ビジネス職など）

## このプロジェクトの特徴

- **コードは書かない**: このリポジトリはドキュメント管理・Claude Code の設定管理用
- **ローカル Markdown が本体**: 記事の作成・編集は `docs/curriculum/` の Markdown ファイルで行う
- **docs 更新**: docs を更新するときは適切にブランチを作って、通常のフローに則りpr/mergeなどする

## エージェント運用ルール

- **メインエージェント（自分）の役割**: 指示の解釈、ブランチ管理、設定ファイルの編集、サブエージェントへの作業委譲
- **`docs/` 以下のファイルを作成・編集するときは、必ず Task tool でサブエージェントに委譲する**
  - サブエージェントは `docs/` 以外を編集できない（フックで制御済み）
  - メインエージェントが直接 `docs/` を編集してはいけない
- メインエージェントは `docs/` 以外（`.claude/`, `.gitignore`, `CLAUDE.md` 等）を直接編集してよい

### サブエージェントの使い分け（`.claude/agents/` 定義済み）

| エージェント | 用途 |
|---|---|
| `writer` | 記事の作成・編集・構成改善・校正 |
| `chief` | 非エンジニア向けのわかりやすさレビュー・技術概念の平易な説明 |
| `tech` | Claude Code の機能・設定に関する解説記事の作成 |

- `docs/` の編集には必ず上記いずれかのカスタムエージェントを使う。`general-purpose` は使わない
- 記事の新規作成・大幅な編集 → `writer`
- 非エンジニア視点での品質チェック → `chief`
- Claude Code の技術解説 → `tech`

## プラグイン（MCP サーバー）

このプロジェクトで利用している MCP プラグイン：

| プラグイン | 用途 |
|---|---|
| `Notion` | Notion ワークスペースとの連携（ページ検索・作成・更新） |
| `context7` | ライブラリドキュメントの検索・参照 |
| `Slack` | Slack チャンネルへの通知・メッセージ送信 |
| `Supabase` | Supabase プロジェクトの管理・SQL 実行 |

- プラグインの権限設定は `.claude/settings.local.json` で管理
- フック（hooks）の設定は `.claude/settings.json` で管理

## スキル

利用可能な主要スキル：

| スキル | 用途 |
|---|---|
| `commit` | Git コミットの作成 |
| `commit-push-pr` | コミット → プッシュ → PR 作成の一連フロー |
| `brainstorming` | 機能追加・設計前のアイデア整理 |
| `writing-plans` | 実装計画の作成 |
| `subagent-driven-development` | 独立タスクの並列実行 |
| `revise-claude-md` | CLAUDE.md の更新・改善 |
| `Notion:tasks:build` | Notion ページからタスクを構築 |

- スキルは `/スキル名` で呼び出す（例: `/commit`）
- 詳細は `/help` で確認可能

## 作業ルール

- 記事は日本語で書く
- 専門用語には必ず平易な説明をつける
- 記事の構成は「結論 → たとえ話 → 詳細 → まとめ」を基本とする
- ファイルの配置: `docs/curriculum/module-NN-<topic>.md`
