# 設計書: Notion 依存の除去とローカル Markdown への移行

**日付**: 2026-02-19
**ブランチ**: docs/github-pages-setup
**方針**: B — 役割再設計（エージェント構成は残し、Notion 連携を全削除）

## 背景・目的

プロジェクトの運用方針を「Notion が本体」から「ローカル Markdown が本体」へ変更する。
GitHub Pages も一旦なし。docs/curriculum/ のローカル Markdown ファイルのみを成果物とする。

## 変更対象

### 更新するファイル

| ファイル | 変更内容 |
|---|---|
| `CLAUDE.md` | 「Notion が本体」記述を削除。ローカル Markdown ワークフローへ書き換え |
| `.claude/agents/pm.md` | Notion ツール参照・記述を削除。ローカル docs 管理役に再定義 |
| `.claude/agents/claude-code-expert.md` | `tools:` から Notion/Slack 系ツールを全削除 |
| `.claude/agents/notion-technical-writer.md` | `writer.md` にリネーム + Notion 依存削除 |
| `.claude/agents/tech-editor-chief.md` | `tools:` から Notion/Slack 系ツールを全削除 |

### 削除するファイル・ディレクトリ

| 対象 | 理由 |
|---|---|
| `docs/notion/` | Notion 由来のすべてのファイル（json/・raw/・markdown/）を削除 |
| `docs/_config.yml` | GitHub Pages 設定（一旦なし） |
| `.claude/skills/sync-notion/` | Notion 専用スキル。不要 |

### 残すもの

- `docs/curriculum/` — コンテンツ本体（ローカル Markdown）
- `docs/plans/` — 設計ドキュメント
- `.claude/hooks/` — restrict-to-docs・notify-slack はそのまま
- `.claude/settings.json` — hooks 設定はそのまま

## エージェントの役割再定義

| エージェント | 旧役割 | 新役割 |
|---|---|---|
| pm | Notion DB 管理 + 記事計画 | docs/curriculum/ のコンテンツ計画・進捗管理 |
| tech | Claude Code 解説 + Notion 投稿 | Claude Code 解説 + ローカル docs/ 編集 |
| writer | Notion テクニカルライター | ローカル Markdown ライター |
| chief | 技術編集長（Notion 投稿） | 技術編集長（ローカル docs/ 編集） |

## 制約

- `.claude/` 配下の編集は Bash 経由（restrict-to-docs フックにより Edit/Write ツールがブロックされるため）
- エージェントの `tools:` から Notion 系（`mcp__plugin_Notion_notion__*`・`mcp__claude_ai_Notion__*`）と Slack 系（`mcp__plugin_slack_slack__*`）を削除する
