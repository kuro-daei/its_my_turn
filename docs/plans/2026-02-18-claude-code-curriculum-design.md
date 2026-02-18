# Claude Code 実践カリキュラム 設計ドキュメント

> 作成日: 2026-02-18
> ステータス: 承認済み

## 概要

Claude Code を実際に触りながら身につける、約10時間のハンズオンカリキュラム。
学習者はメンター付きで進め、最終的に Supabase + Vercel の TODO アプリを完成させる。

## 要件

| 項目 | 内容 |
|------|------|
| 対象者 | PC操作に慣れた非エンジニア（ターミナルは少し使える程度） |
| 形式 | メンター付きハンズオン |
| 時間 | 約10時間 |
| 座学 | ほぼなし。全て実践ベース |
| OS対応 | Mac / Windows 両対応 |
| 成果物（アプリ） | TODO アプリ（Next.js + Supabase + Vercel） |
| 成果物（学習） | Claude Code の主要機能を一通り使える |
| カリキュラム出力先 | Notion（データベース形式） |
| ワークフロー | 中間ファイルはローカル保存 → 最後にNotionへ出力 |

## 使用ツール・サービス

- **Claude Code**: メインの学習対象
- **Next.js (App Router)**: Web フレームワーク
- **Tailwind CSS**: スタイリング
- **Supabase**: データベース + 認証（SPA ベース）
- **Vercel**: ホスティング・デプロイ
- **Figma**: UI デザイン（Figma MCP で双方向連携）
- **Slack**: 通知（Hooks 連携）
- **Git**: バージョン管理

## チーム構成（エージェント）

| エージェント | 役割 |
|-------------|------|
| claude-code-expert | Claude Code の機能・設定・ベストプラクティスの専門家 |
| notion-technical-writer | 編集者・テクニカルライター・Notion エキスパート |
| tech-editor-chief | 非エンジニア向けにわかりやすく伝える編集長 |

## アプローチ

**プロジェクト駆動型**: アプリ開発の流れに沿って、必要になったタイミングで Claude Code の機能を学ぶ。

## モジュール構成

### Module 0: 環境準備（1h）

**ゴール**: Claude Code でコードが書ける状態にする

**手順（Mac / Windows 両対応）**:

| ステップ | Mac | Windows |
|---------|-----|---------|
| Node.js | `brew install node` | 公式インストーラー or `winget install OpenJS.NodeJS.LTS` |
| Git | `xcode-select --install` | Git for Windows インストーラー |
| ターミナル | Terminal.app（標準） | Windows Terminal + WSL2（推奨）or PowerShell |
| Claude Code | `npm install -g @anthropic-ai/claude-code` | 同左 |
| API Key | Anthropic Console でキー取得 → `ANTHROPIC_API_KEY` 設定 | 同左 |

**確認ポイント**:
- `claude --version` が動く
- `node --version` / `git --version` が動く

> **この章は随時更新**: 後のモジュールで新しいライブラリが必要になったら、ここに追記する。
> 追記予定: Figma アカウント、Supabase アカウント、Vercel アカウント、各種 npm パッケージ

---

### Module 1: Claude Code を整える（1h）

**ゴール**: CLAUDE.md、エージェントチーム、プラグイン、Slack Hook が稼働している状態

**学ぶ Claude Code 機能**: CLAUDE.md、Hooks、Agents、MCP

| Step | 内容 | 時間 |
|------|------|------|
| 1 | CLAUDE.md を書く: `/init` で自動生成 → 手動でカスタマイズ。書く前と書いた後で挙動比較 | 15min |
| 2 | プラグイン設定: Slack MCP、Figma MCP の接続。`.claude/settings.json` の構造を確認 | 15min |
| 3 | エージェントチーム構築: `.claude/agents/` に3つのエージェント定義ファイルを配置。エージェントに話しかけて応答確認 | 20min |
| 4 | Slack Hook 設定: `TaskCompleted` Hook → Slack 通知。動作確認 | 10min |

---

### Module 2: プロジェクト初期化（1h）

**ゴール**: Next.js アプリが localhost で動いている + Git ブランチ戦略が整っている

**学ぶ Claude Code 機能**: スキャフォールド指示、Git 操作

| Step | 内容 | 時間 |
|------|------|------|
| 1 | Next.js スキャフォールド: Claude Code に指示 → TypeScript, Tailwind, App Router, src ディレクトリ | 20min |
| 2 | Git 初期化 & ブランチ戦略: 初回コミット、CLAUDE.md にブランチ命名規則追記、`feature/setup` で作業開始 | 20min |
| 3 | 動作確認: `npm run dev` → ブラウザ確認。Claude Code にファイル構成を説明してもらう | 20min |

---

### Module 3: UI を作る（1.5h）

**ゴール**: Figma でデザインした TODO リストが Next.js で表示される

**学ぶ Claude Code 機能**: Figma MCP（双方向）、プロンプティング、反復修正

| Step | 内容 | 時間 |
|------|------|------|
| 1 | Claude Code → Figma: Claude Code に「TODO アプリの UI を Figma にデザインして」と指示。Figma MCP でデザイン自動生成 | 30min |
| 2 | Figma で確認・調整: 生成されたデザインを確認、好みに合わせて手動微調整 | 20min |
| 3 | Figma → Claude Code で実装: Figma MCP でデザインデータ取得 → Tailwind CSS で実装。反復修正、コンポーネント分割 | 40min |

---

### Module 4: Supabase 初期設定（30min）

**ゴール**: Supabase プロジェクトが立ち上がり、接続できる状態

**学ぶ Claude Code 機能**: DB 設計指示、SQL 生成

- Supabase プロジェクト作成
- `todos` テーブル設計（id, title, completed, created_at, user_id）→ Claude Code に SQL 生成依頼
- `.env.local` に接続情報設定
- Supabase クライアント初期化
- `@supabase/supabase-js` インストール（→ Module 0 追記）

---

### Module 5: 初期開発 — Web + Supabase + 認証を一気通貫（3h）

**ゴール**: TODO アプリが一通り動く状態（CRUD + SPA 認証）

**学ぶ Claude Code 機能**: 統合的な指示、エージェント活用、タスク分解、環境変数管理

| Step | 内容 | 時間 |
|------|------|------|
| 1 | TODO CRUD を UI と DB 同時に作る: 追加 → 一覧 → 完了切り替え → 削除。機能単位で進める | 1.5h |
| 2 | SPA 認証を組み込む: ログイン/サインアップ + Supabase Auth + RLS。エージェント活用 | 1h |
| 3 | 通し確認 & 初期開発コミット: サインアップ → ログイン → CRUD → ログアウト。`feature/initial-development` でコミット | 30min |

---

### Module 6: 修正・改善（Git ワークフロー）（1.5h）

**ゴール**: バグ修正や改善をブランチ運用で進める実務フローを体験

**学ぶ Claude Code 機能**: コードレビュー、Git ブランチ運用、CLAUDE.md ルールの効果

| Step | 内容 | 時間 |
|------|------|------|
| 1 | コードレビュー: Claude Code に「レビューして」→ 指摘事項リストアップ | 20min |
| 2 | 修正ブランチで対応: `fix/review-feedback` → 指摘を1つずつ修正 → コミット | 40min |
| 3 | 機能改善ブランチ: `feature/ui-polish` → UI 微調整、エラーハンドリング強化 | 30min |

---

### Module 7: Vercel デプロイ（1h）

**ゴール**: 公開 URL で TODO アプリが動く

**学ぶ Claude Code 機能**: CI/CD 連携、本番設定

| Step | 内容 | 時間 |
|------|------|------|
| 1 | Vercel 設定: アカウント作成、CLI インストール（→ Module 0 追記）、GitHub 連携 | 20min |
| 2 | 環境変数 & デプロイ: Supabase 環境変数を Vercel に設定、`vercel deploy` 実行 | 20min |
| 3 | 本番確認 & 振り返り: 公開 URL で動作確認、Auth リダイレクト URL 更新、Slack 完了通知 | 20min |

---

## Notion 出力仕様

- **形式**: データベース
- **タイミング**: 全モジュール完成後にまとめて出力
- **プロパティ**: Title, Status, Time, Module, 学ぶ機能

## ワークフロー

1. 各エージェントが中間ファイルをローカル（`docs/` 配下）に保存
2. 各エージェントは中間ファイルを参照しながら作業
3. 全モジュール完成後、Notion にまとめて出力
