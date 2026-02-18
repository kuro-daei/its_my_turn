# Claude Code 実践カリキュラム 実装計画

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 非エンジニア向け Claude Code 実践ハンズオンカリキュラム（全8モジュール）を作成し、Notion データベースに出力する

**Architecture:** 3エージェント（claude-code-expert、tech-editor-chief、notion-technical-writer）が分業。各モジュールは claude-code-expert が技術ドラフトを書き、tech-editor-chief が非エンジニア向けにリライトし、notion-technical-writer が最終構成を整える。中間ファイルは `docs/curriculum/` に保存。全モジュール完成後に Notion へ一括出力。

**Tech Stack:** Markdown（中間ファイル）、Notion MCP（最終出力）、Slack MCP（通知）

**設計ドキュメント:** `docs/plans/2026-02-18-claude-code-curriculum-design.md`

---

## ファイル構成

```
docs/curriculum/
  module-00-setup.md          # Module 0: 環境準備
  module-01-claude-code.md     # Module 1: Claude Code を整える
  module-02-project-init.md    # Module 2: プロジェクト初期化
  module-03-ui.md              # Module 3: UI を作る
  module-04-supabase-setup.md  # Module 4: Supabase 初期設定
  module-05-development.md     # Module 5: 初期開発
  module-06-git-workflow.md    # Module 6: 修正・改善
  module-07-deploy.md          # Module 7: Vercel デプロイ
```

## エージェント担当と作業フロー

各モジュールは以下の3ステップで作成する:

1. **claude-code-expert（ドラフト）**: 技術的に正確な手順・コマンド・設定例を書く
2. **tech-editor-chief（リライト）**: 非エンジニアが迷わない表現に書き換える。たとえ話、用語解説を追加
3. **notion-technical-writer（最終編集）**: Notion 出力に適した構成に整える。チェックリスト、コールアウトを活用

**並列化ルール**: Module 間は並列化可能。同じ Module の3ステップは順次実行。

---

## Phase 1: ディレクトリ準備

### Task 1: 作業ディレクトリ作成

**担当:** リーダー（自分）

**Step 1: ディレクトリ作成**

```bash
mkdir -p docs/curriculum
```

**Step 2: コミット**

```bash
git add docs/curriculum
git commit -m "docs: add curriculum directory structure"
```

---

## Phase 2: モジュールコンテンツ作成

### Task 2: Module 0 — 環境準備

**担当:** claude-code-expert → tech-editor-chief → notion-technical-writer
**出力:** `docs/curriculum/module-00-setup.md`

**claude-code-expert が書く内容:**
- Node.js インストール手順（Mac: brew / Windows: winget + 公式インストーラー）
- Git インストール手順（Mac: xcode-select / Windows: Git for Windows）
- ターミナル環境（Mac: Terminal.app / Windows: Windows Terminal + WSL2 推奨、PowerShell 代替）
- Claude Code インストール（`npm install -g @anthropic-ai/claude-code`）
- API Key 取得手順（Anthropic Console）
- 確認コマンド一覧（`claude --version`, `node --version`, `git --version`）
- **随時追記セクション**のテンプレート（後続モジュールで追記する枠）

**tech-editor-chief がリライトする観点:**
- 「ターミナル」「CLI」「npm」などの用語に初出時の説明を追加
- Mac/Windows の違いを表ではなく、OS ごとのセクションに分けて迷わない構成に
- 「うまくいかない場合は」のトラブルシュート欄を各ステップに追加

**notion-technical-writer が仕上げる観点:**
- 各ステップに完了チェックボックスを追加
- コマンドはコードブロック、注意点はコールアウトで表現
- スクリーンショット挿入ポイントを `[screenshot: 説明]` で指示

---

### Task 3: Module 1 — Claude Code を整える

**担当:** claude-code-expert → tech-editor-chief → notion-technical-writer
**出力:** `docs/curriculum/module-01-claude-code.md`

**claude-code-expert が書く内容:**
- Step 1: CLAUDE.md の作成
  - `/init` コマンドの実行手順
  - CLAUDE.md に書くべき内容（プロジェクト概要、スタック、コーディングルール）
  - CLAUDE.md が Claude の挙動にどう影響するかの比較デモ手順
- Step 2: プラグイン設定
  - Slack MCP プラグインの接続手順
  - Figma MCP プラグインの接続手順（Personal Access Token 取得含む）
  - `.claude/settings.json` の設定例（完全なJSON）
- Step 3: エージェントチーム構築
  - `.claude/agents/` ディレクトリの作成
  - 3つのエージェント定義ファイルの内容（そのまま貼れるレベル）
  - エージェントへの呼びかけデモ手順
- Step 4: Slack Hook 設定
  - `.claude/settings.json` への hooks 設定（完全なJSON）
  - `notify-slack.sh` スクリプトの内容
  - 動作確認手順

**tech-editor-chief がリライトする観点:**
- 「MCP」「Hook」「エージェント」を日常のたとえで説明
- 「なぜこの設定が必要か」を各ステップに追加
- 設定ファイルの各行にコメントで意味を説明

**notion-technical-writer が仕上げる観点:**
- 設定ファイルはトグルブロック内にコードブロックで配置
- 「体験ポイント」をハイライトで強調

---

### Task 4: Module 2 — プロジェクト初期化

**担当:** claude-code-expert → tech-editor-chief → notion-technical-writer
**出力:** `docs/curriculum/module-02-project-init.md`

**claude-code-expert が書く内容:**
- Step 1: Next.js スキャフォールド
  - Claude Code への具体的な指示文例
  - `create-next-app` のオプション解説（TypeScript, Tailwind, App Router, src ディレクトリ）
  - 生成されるファイル構成の説明
- Step 2: Git 初期化 & ブランチ戦略
  - `git init` → 初回コミットの手順
  - CLAUDE.md へのブランチ命名規則追記内容
  - `feature/setup` ブランチ作成手順
  - Claude Code に「コミットして」と頼む具体的な指示例
- Step 3: 動作確認
  - `npm run dev` → ブラウザ確認手順
  - Claude Code に「src/ の中身を説明して」と聞くデモ
  - Module 0 への追記: なし（このモジュールで新規ライブラリは不要）

---

### Task 5: Module 3 — UI を作る

**担当:** claude-code-expert → tech-editor-chief → notion-technical-writer
**出力:** `docs/curriculum/module-03-ui.md`

**claude-code-expert が書く内容:**
- Step 1: Claude Code → Figma でデザイン生成
  - Figma MCP を使ったデザイン生成の具体的な指示文例
  - 期待される Figma 上の出力（TODO リスト、追加フォーム、完了/削除ボタン）
- Step 2: Figma で確認・調整
  - 学習者が手動で調整するポイントの案内
  - AI が作ったものを人が仕上げる協業パターンの解説
- Step 3: Figma → Claude Code で実装
  - Figma MCP でデザインデータを取得して実装する指示文例
  - 反復修正の指示例（「余白をもう少し広く」「色をFigmaに合わせて」）
  - コンポーネント分割の指示例（Header, TodoList, TodoItem, AddTodoForm）

---

### Task 6: Module 4 — Supabase 初期設定

**担当:** claude-code-expert → tech-editor-chief → notion-technical-writer
**出力:** `docs/curriculum/module-04-supabase-setup.md`

**claude-code-expert が書く内容:**
- Supabase プロジェクト作成手順（ダッシュボード操作）
- `todos` テーブルの SQL（Claude Code に生成させる指示例と期待される SQL）
- `.env.local` の設定内容
- Supabase クライアント初期化コード（`lib/supabase.ts`）
- `@supabase/supabase-js` のインストールコマンド
- Module 0 への追記内容: Supabase アカウント作成、`@supabase/supabase-js`

---

### Task 7: Module 5 — 初期開発（Web + Supabase + 認証）

**担当:** claude-code-expert → tech-editor-chief → notion-technical-writer
**出力:** `docs/curriculum/module-05-development.md`

**claude-code-expert が書く内容:**
- Step 1: TODO CRUD（1.5h）
  - 追加機能: 指示例 + 期待されるコード概要
  - 一覧表示: 指示例 + 期待されるコード概要
  - 完了切り替え: 指示例 + 期待されるコード概要
  - 削除: 指示例 + 期待されるコード概要
  - 「フロントもバックも同時に作って」という指示の出し方
- Step 2: SPA 認証（1h）
  - `@supabase/auth-helpers-nextjs` or `@supabase/ssr` の選定理由
  - ログイン/サインアップ画面の指示例
  - 認証状態管理の指示例
  - RLS 設定の SQL（Claude Code に生成させる指示例）
  - Module 0 への追記内容: 認証関連パッケージ
- Step 3: 通し確認 & コミット
  - テストシナリオ（サインアップ → ログイン → CRUD → ログアウト）
  - `feature/initial-development` でのコミット手順

---

### Task 8: Module 6 — 修正・改善（Git ワークフロー）

**担当:** claude-code-expert → tech-editor-chief → notion-technical-writer
**出力:** `docs/curriculum/module-06-git-workflow.md`

**claude-code-expert が書く内容:**
- Step 1: コードレビュー
  - 「このプロジェクトをレビューして」の指示例
  - 期待されるレビュー観点（パフォーマンス、セキュリティ、可読性）
- Step 2: 修正ブランチ
  - `fix/review-feedback` ブランチ作成 → 修正 → コミットの一連の流れ
  - Conventional Commits の `fix:` プレフィックスの使い方
- Step 3: 機能改善ブランチ
  - `feature/ui-polish` ブランチ作成 → 改善 → コミット
  - `feature:` プレフィックスとの使い分け
  - CLAUDE.md のブランチルールが効いていることの確認方法

---

### Task 9: Module 7 — Vercel デプロイ

**担当:** claude-code-expert → tech-editor-chief → notion-technical-writer
**出力:** `docs/curriculum/module-07-deploy.md`

**claude-code-expert が書く内容:**
- Step 1: Vercel 設定
  - Vercel アカウント作成手順
  - Vercel CLI インストール（`npm i -g vercel`）
  - GitHub リポジトリ連携手順
  - Module 0 への追記: Vercel アカウント、Vercel CLI
- Step 2: デプロイ
  - 環境変数設定（Supabase URL, Key）
  - `vercel deploy` の実行手順
  - Claude Code に「Vercel にデプロイして」と指示する例
- Step 3: 本番確認 & 振り返り
  - 公開 URL での動作確認チェックリスト
  - Supabase Auth リダイレクト URL の本番用更新手順
  - 10時間で学んだ Claude Code 機能の振り返りリスト
  - Slack 完了通知の確認

---

## Phase 3: Module 0 の最終更新

### Task 10: Module 0 に全追記を反映

**担当:** claude-code-expert → notion-technical-writer
**出力:** `docs/curriculum/module-00-setup.md`（更新）

Module 4〜7 で発生した追記内容を Module 0 にまとめて反映:
- Figma アカウント + Personal Access Token
- Supabase アカウント + `@supabase/supabase-js`
- 認証パッケージ（`@supabase/ssr` or `@supabase/auth-helpers-nextjs`）
- Vercel アカウント + Vercel CLI

---

## Phase 4: Notion 出力

### Task 11: Notion データベース作成 & コンテンツ出力

**担当:** notion-technical-writer
**入力:** `docs/curriculum/module-*.md`（全8ファイル）

**Step 1: Notion データベース作成**

プロパティ:
| プロパティ名 | 型 | 値 |
|-------------|------|------|
| Title | Title | モジュール名 |
| Status | Select | Not Started / In Progress / Done |
| Time | Text | 所要時間 |
| Module | Number | 0-7 |
| 学ぶ機能 | Multi-select | CLAUDE.md / Hooks / Agents / MCP / Git / etc. |

**Step 2: 各モジュールをデータベース行として追加**

各行のページ内容に、完成した Markdown コンテンツを Notion ブロックとして出力。

**Step 3: Slack に完了通知**

カリキュラム完成をSlackに通知。

---

## 実行スケジュール

**並列化戦略:**
- Task 2〜5 は並列実行可能（Module 0〜3 は相互依存なし）
- Task 6 は Task 5 の後（Module 4 の追記内容が Module 5 に影響）
- Task 7 は Task 6 の後（認証パッケージの選定が必要）
- Task 8〜9 は Task 7 の後（コードレビュー対象が必要）
- Task 10 は Task 2〜9 完了後
- Task 11 は Task 10 完了後

```
Task 2 (Mod 0) ──┐
Task 3 (Mod 1) ──┤
Task 4 (Mod 2) ──┼── Task 6 (Mod 4) ── Task 7 (Mod 5) ──┬── Task 10 (Mod 0 更新) ── Task 11 (Notion)
Task 5 (Mod 3) ──┘                                       │
                                                          ├── Task 8 (Mod 6)
                                                          └── Task 9 (Mod 7)
```
