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

**このプロジェクトのドキュメント作業は、基本的に `doc-writer-team` エージェントが担当する。**

- **メインエージェント（自分）の役割**: 指示の解釈、ブランチ管理、設定ファイルの編集、サブエージェントへの作業委譲
- **`docs/` 以下のファイルを作成・編集するときは、必ず `doc-writer-team` スキルのエージェントに委譲する**
  - メインエージェントが直接 `docs/` を編集してはいけない
- メインエージェントは `docs/` 以外（`.claude/`, `.gitignore`, `CLAUDE.md` 等）を直接編集してよい

### doc-writer-team エージェントの使い分け

| エージェント | 用途 |
|---|---|
| `doc-writer-team:editor-in-chief` | ドキュメント作成の全体統括（調査→構成→執筆→レビュー→保存のパイプライン） |
| `doc-writer-team:deep-researcher` | トピックの調査・情報収集（Web検索・フェッチ） |
| `doc-writer-team:technical-writer` | 調査内容をもとにしたドキュメントの執筆・改訂 |
| `doc-writer-team:reviewer` | 正確性・わかりやすさ・構成のレビュー |

- 記事の新規作成・大幅な編集 → `doc-writer-team:editor-in-chief`（自動でチームを統括）
- 特定工程だけ実行する場合は個別エージェントを呼び出す
- スキルとして呼び出す場合: `/doc-writer-team:doc-writer` （トピックと出力ディレクトリを指定）

## プラグイン（MCP サーバー）

このプロジェクトで利用している MCP プラグイン：

| プラグイン | 用途 |
|---|---|
| `context7` | ライブラリドキュメントの検索・参照 |

- プラグインの権限設定は `.claude/settings.local.json` で管理
- フック（hooks）の設定は `.claude/settings.json` で管理

## スキル

利用可能な主要スキル：

| スキル | 用途 |
|---|---|
| `commit-commands:commit` | Git コミットの作成 |
| `commit-commands:commit-push-pr` | コミット → プッシュ → PR 作成の一連フロー |
| `commit-commands:clean_gone` | リモート削除済みブランチのローカル掃除 |
| `claude-md-management:revise-claude-md` | CLAUDE.md の更新・改善 |
| `claude-md-management:claude-md-improver` | CLAUDE.md の監査・品質チェック |
| `doc-writer-team:doc-writer` | トピックを調査してドキュメント一式を作成する |
| `doc-review` | カリキュラム全体の整合性・構成をレビューする |

- スキルは `/スキル名` で呼び出す（例: `/commit-commands:commit`）
- 詳細は `/help` で確認可能

## 作業ルール

- 記事は日本語で書く
- 専門用語には必ず平易な説明をつける
- 記事の構成は「結論 → たとえ話 → 詳細 → まとめ」を基本とする
- ファイルの配置: `docs/curriculum/chapter-NN-<topic>.md`
- コードブロックは次のルールで先頭に # bash などを書く
  - bash -> # bash
  - claude -> # claude
  - output -> # output
  - other -> (なし)

## カリキュラムの性質

- **ハンズオン形式**: 読者が実際に手を動かしながら進めることを前提としている
- **章の連続性**: 各章は前の章の作業結果を引き継いで進む。順番通りに実行することを想定
- **ナビゲーションリンク**: 各章ファイルの末尾には前後の章へのリンクを必ずつける

### ナビゲーションリンクの書き方

各章ファイルの末尾に以下の形式でリンクを記載する：

```
---

[← 前の章タイトル](前のファイル名.md) | [次の章タイトル →](次のファイル名.md)
```

- 先頭章は「次へ」リンクのみ
- 最終章は「前へ」リンクのみ
- 補足資料（supplement-XX）は前後リンク不要