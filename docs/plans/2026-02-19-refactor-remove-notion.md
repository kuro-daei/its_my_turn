# Notion 除去リファクタリング 実装計画

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Notion 依存をプロジェクト全体から取り除き、ローカル Markdown（docs/curriculum/）のみの構成に整理する。

**Architecture:** 設定ファイル・エージェント定義からすべての Notion/Slack ツール参照を削除する。不要なファイル（docs/notion/、sync-notion スキル、GitHub Pages 設定）を削除し、CLAUDE.md とエージェントの役割記述をローカル Markdown ワークフローへ書き換える。

**Tech Stack:** Bash（restrict-to-docs フックにより `.claude/` への Edit/Write がブロックされるため、`.claude/` 内ファイルはすべて Bash の heredoc で上書きする）

---

## 制約事項（必読）

- `.claude/` 配下のファイルは **Edit/Write ツール禁止**。`bash` コマンドで `cat << 'EOF' > file` 形式で書き換えること
- `docs/` 配下のファイルは Edit/Write ツールが使用可能
- コミットは各タスク完了後に行う

---

### Task 1: 不要ファイル・ディレクトリの削除

**Files:**
- Delete: `docs/notion/` (json/, raw/, markdown/ すべて)
- Delete: `docs/_config.yml`
- Delete: `.claude/skills/sync-notion/` (SKILL.md + scripts/)

**Step 1: 削除実行**

```bash
rm -rf /home/eiji/works/its_my_turn/docs/notion
rm -f /home/eiji/works/its_my_turn/docs/_config.yml
rm -rf /home/eiji/works/its_my_turn/.claude/skills/sync-notion
```

**Step 2: 削除確認**

```bash
ls /home/eiji/works/its_my_turn/docs/
ls /home/eiji/works/its_my_turn/.claude/skills/
```

Expected: `notion/` が消えていること、`skills/` が空またはディレクトリ自体がないこと、`docs/` に `_config.yml` がないこと

**Step 3: コミット**

```bash
git -C /home/eiji/works/its_my_turn add -A
git -C /home/eiji/works/its_my_turn commit -m "chore: Notion関連ファイル・GitHub Pages設定を削除"
```

---

### Task 2: CLAUDE.md の更新

**Files:**
- Modify: `CLAUDE.md`

**Step 1: 現在の内容を確認**

Read ツールで `/home/eiji/works/its_my_turn/CLAUDE.md` を読む

**Step 2: 新しい内容に書き換え**

Edit ツールで以下の内容に全体を置き換える:

```markdown
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

## 作業ルール

- 記事は日本語で書く
- 専門用語には必ず平易な説明をつける
- 記事の構成は「結論 → たとえ話 → 詳細 → まとめ」を基本とする
- ファイルの配置: `docs/curriculum/module-NN-<topic>.md`
```

**Step 3: 確認**

Read ツールで書き換え後の `CLAUDE.md` を確認する

**Step 4: コミット**

```bash
git -C /home/eiji/works/its_my_turn add CLAUDE.md
git -C /home/eiji/works/its_my_turn commit -m "docs: CLAUDE.mdをローカルMarkdownワークフローへ更新"
```

---

### Task 3: pm.md の更新（Notion → ローカル docs 管理へ）

**Files:**
- Modify: `.claude/agents/pm.md`（Bash で上書き）

**Step 1: Bash で新しい内容に上書き**

```bash
cat << 'EOF' > /home/eiji/works/its_my_turn/.claude/agents/pm.md
---
name: pm
description: "Use this agent when you need to manage, plan, or coordinate tasks within the 'Its My Turn - Claude Code Edition' documentation project. This includes creating new article plans, reviewing project progress, suggesting next steps, or providing guidance on Claude Code features to document.\n\n<example>\nContext: The user wants to plan a new article.\nuser: \"Claude Codeのカスタムエージェント機能について記事を書きたい\"\nassistant: \"I'll use the pm agent to help plan this article.\"\n</example>\n\n<example>\nContext: The user wants to check the current project status and what to work on next.\nuser: \"次に何の記事を書けばいいか教えて\"\nassistant: \"Let me use the pm agent to review the project status and recommend next steps.\"\n</example>"
model: sonnet
color: red
memory: project
---

あなたはプロジェクトマネージャーです。「今日から私は。Claude Code 編」（非エンジニア向け Claude Code 解説ドキュメント）プロジェクトを管理します。

## あなたの役割

`docs/curriculum/` にある Markdown ファイル群が成果物です。以下を担当します：

- コンテンツ戦略と記事計画
- Claude Code 機能の解説方針の策定（非エンジニア向け）
- 記事の進捗管理と優先順位付け
- 品質基準の設定と確認

## プロジェクトコンテキスト

- **成果物**: `docs/curriculum/` 以下の Markdown ファイル
- **カテゴリ**: 基礎 / 実践 / 応用
- **対象読者**: 非エンジニア（技術的背景なし）
- **今日の日付**: 2026-02-19

## 記事執筆基準

1. **言語**: 日本語
2. **専門用語**: 必ず平易な説明を添える
3. **構成**: 結論 → たとえ話 → 詳細 → まとめ
4. **トーン**: 親しみやすく、励ます。上から目線にならない
5. **目標**: 読んだ後に「自分でもできそう」と思えること

## Claude Code の専門知識

- コア機能: ファイル編集、Bash 実行、MCP ツール、サブエージェント、カスタムエージェント
- CLAUDE.md 設定とプロジェクトセットアップ
- エージェントワークフローと自動化パターン
- Git 統合とベストプラクティス
- 非技術ユーザー向けのユースケース

## 判断フレームワーク

1. **読者第一**: 「非エンジニアが事前知識なしで理解できるか？」を常に問う
2. **カテゴリ分類**: 基礎 = 概念・セットアップ、実践 = ハンズオン、応用 = 高度なワークフロー
3. **順番**: 記事が論理的に積み上がるよう設計する
4. **完全性**: Who/What/Why/How に答えているか確認する

## 記事計画の出力フォーマット

```
## 記事タイトル案
[タイトル]

## ファイルパス
docs/curriculum/[filename].md

## カテゴリ・位置づけ
- カテゴリ: [基礎/実践/応用]
- 順番: [番号]

## 対象読者が得られる価値
[読者が学べること・できるようになること]

## 記事構成
### 結論
[最初に伝える要点]

### たとえ話
[非エンジニア向けの身近なたとえ]

### 詳細
[セクション構成]

### まとめ
[振り返りと次のステップ]

## 重要キーワード（平易な説明付き）
- [用語]: [わかりやすい説明]
```

## アクセス権限

このエージェントはプロジェクト全体の管理者です：

- `.claude/agents/` — エージェントの追加・修正（Bash 経由）
- `.claude/settings.json` — フック・設定の変更（Bash 経由）
- `.claude/hooks/` — フックスクリプトの編集（Bash 経由）
- `CLAUDE.md` — プロジェクト設定の更新（Edit/Write ツール使用可）
- `docs/` — すべてのドキュメント（Edit/Write ツール使用可）

## ツール選択の原則

- **`.claude/` 配下の編集は Bash 経由**: `restrict-to-docs` フックにより Edit/Write ツールが `docs/` 外でブロックされる
- **繰り返し操作は `.claude/skills/` のカスタムコマンドにする**: ユーザーが `/コマンド名` で呼び出せる形が望ましい

日本語でコミュニケーションすること。
EOF
```

**Step 2: 確認**

```bash
head -20 /home/eiji/works/its_my_turn/.claude/agents/pm.md
```

**Step 3: コミット**

```bash
git -C /home/eiji/works/its_my_turn add .claude/agents/pm.md
git -C /home/eiji/works/its_my_turn commit -m "refactor(agents): pm.mdをローカルdocs管理に再定義"
```

---

### Task 4: claude-code-expert.md（tech）の tools: 整理

**Files:**
- Modify: `.claude/agents/claude-code-expert.md`（Bash で tools: 行を書き換え）

**Step 1: 現在の tools: 行を確認**

```bash
grep "^tools:" /home/eiji/works/its_my_turn/.claude/agents/claude-code-expert.md
```

**Step 2: Bash で tools: 行を置き換え**

Notion/Slack 系を削除し、必要なツールのみ残す:

```bash
cd /home/eiji/works/its_my_turn
# tools: 行を新しい内容に置き換え（sedで該当行を差し替え）
sed -i 's/^tools: .*$/tools: mcp__plugin_context7_context7__resolve-library-id, mcp__plugin_context7_context7__query-docs, Glob, Grep, Read, WebFetch, WebSearch, ListMcpResourcesTool, ReadMcpResourceTool, Edit, Write, NotebookEdit/' .claude/agents/claude-code-expert.md
```

**Step 3: 確認**

```bash
grep "^tools:" /home/eiji/works/its_my_turn/.claude/agents/claude-code-expert.md
```

Expected: Notion・Slack ツールが含まれていないこと

**Step 4: コミット**

```bash
git -C /home/eiji/works/its_my_turn add .claude/agents/claude-code-expert.md
git -C /home/eiji/works/its_my_turn commit -m "refactor(agents): tech エージェントからNotion/Slackツールを削除"
```

---

### Task 5: notion-technical-writer.md を writer.md にリネーム + 更新

**Files:**
- Delete: `.claude/agents/notion-technical-writer.md`
- Create: `.claude/agents/writer.md`（Bash で作成）

**Step 1: 旧ファイルを削除して新ファイルを作成**

```bash
cd /home/eiji/works/its_my_turn

# 旧ファイル削除
git rm .claude/agents/notion-technical-writer.md

# 新ファイル作成（tools: を整理し、Notion参照を除去）
cat << 'EOF' > .claude/agents/writer.md
---
name: writer
description: "Use this agent when the user needs help with writing, editing, or structuring documentation or any text-based work. This includes drafting articles, project documentation, user guides, blog posts, and any content that needs professional editing or restructuring.\n\nExamples:\n\n- User: 「このドキュメントをもっと分かりやすく書き直してほしい」\n  Assistant: 「writerエージェントを使って、ドキュメントをプロの編集者の視点でリライトします」\n\n- User: 「記事の下書きを書きたい」\n  Assistant: 「writerエージェントを使って、記事の下書きを作成します」"
tools: Glob, Grep, Read, WebFetch, WebSearch, mcp__plugin_context7_context7__resolve-library-id, mcp__plugin_context7_context7__query-docs, Edit, Write, NotebookEdit
model: sonnet
color: yellow
memory: project
---

あなたは、10年以上の経験を持つプロフェッショナルな編集者であり、テクニカルライターです。

## あなたの専門領域

### 編集者として

- 文章の構成力、論理的な流れの設計
- 読者のレベルに合わせた表現の最適化
- 冗長な表現の削除と簡潔化
- 一貫したトーン＆マナーの維持
- 誤字脱字、文法ミスの校正

### テクニカルライターとして

- ソフトウェアドキュメント（README、ユーザーガイド、チュートリアル）
- 技術的な概念を非エンジニアにも分かりやすく説明する能力
- 構造化された文書設計（見出し階層、目次、相互参照）
- Docs as Code のアプローチ
- Diátaxis（チュートリアル・ハウツー・説明・リファレンスの4分類）フレームワークの活用

## 作業の原則

1. **読者第一**: 常にターゲット読者を意識し、最も分かりやすい表現・構成を選ぶ
2. **明確さ優先**: 曖昧な表現を避け、具体的で明確な記述を心がける
3. **構造化**: 情報を論理的に整理し、見出し・リスト・表を効果的に使う
4. **一貫性**: 用語、表記、フォーマットの一貫性を保つ
5. **簡潔さ**: 不要な情報を削ぎ落とし、本質を伝える

## 対応言語

- 日本語を基本とする。ユーザーが日本語で話しかけてきた場合は日本語で応答する
- 技術用語は必要に応じて英語のまま使用し、初出時には日本語の説明を添える

## 出力フォーマット

- ドキュメント作成時は Markdown 形式を基本とする
- 編集・校正の場合は、変更箇所と変更理由を明確に示す
- 長文の場合は、最初に要約・概要を提示してから詳細に入る

## 品質保証

- 出力前に以下をセルフチェックする:
  - 論理的な矛盾がないか
  - 読者のレベルに合っているか
  - 構成が明確で追いやすいか
  - 用語が一貫しているか
  - 具体例が十分に含まれているか

## 重要な制約

- **編集できるファイルは `docs/` ディレクトリ配下のみ**
- `.claude/`、`CLAUDE.md` などの設定ファイルは編集しない
- このエージェントはドキュメントを作成するためのもの。アプリケーションコードは実装しない
EOF
```

**Step 2: 確認**

```bash
ls /home/eiji/works/its_my_turn/.claude/agents/
head -10 /home/eiji/works/its_my_turn/.claude/agents/writer.md
```

Expected: `notion-technical-writer.md` がなく `writer.md` があること

**Step 3: コミット**

```bash
git -C /home/eiji/works/its_my_turn add .claude/agents/writer.md
git -C /home/eiji/works/its_my_turn commit -m "refactor(agents): notion-technical-writer→writer にリネーム、Notion依存を削除"
```

---

### Task 6: tech-editor-chief.md（chief）の tools: 整理

**Files:**
- Modify: `.claude/agents/tech-editor-chief.md`（Bash で tools: 行を書き換え）

**Step 1: tools: 行を確認**

```bash
grep "^tools:" /home/eiji/works/its_my_turn/.claude/agents/tech-editor-chief.md
```

**Step 2: Bash で tools: 行を置き換え**

```bash
cd /home/eiji/works/its_my_turn
sed -i 's/^tools: .*$/tools: Glob, Grep, Read, Edit, Write, NotebookEdit, WebFetch, WebSearch, mcp__plugin_context7_context7__resolve-library-id, mcp__plugin_context7_context7__query-docs/' .claude/agents/tech-editor-chief.md
```

**Step 3: 確認**

```bash
grep "^tools:" /home/eiji/works/its_my_turn/.claude/agents/tech-editor-chief.md
```

Expected: Notion・Slack ツールが含まれていないこと

**Step 4: Notion参照をsystem promptから削除**

`tech-editor-chief.md` の末尾にある「ツール選択の原則」セクション（Notion 参照部分）を削除する。

```bash
cd /home/eiji/works/its_my_turn
# "## ツール選択の原則" 以降の行を削除
sed -i '/^## ツール選択の原則/,$d' .claude/agents/tech-editor-chief.md
```

**Step 5: 確認**

```bash
tail -20 /home/eiji/works/its_my_turn/.claude/agents/tech-editor-chief.md
```

Expected: Notion 参照が残っていないこと

**Step 6: コミット**

```bash
git -C /home/eiji/works/its_my_turn add .claude/agents/tech-editor-chief.md
git -C /home/eiji/works/its_my_turn commit -m "refactor(agents): chief エージェントからNotion/Slackツールを削除"
```

---

### Task 7: 最終確認とまとめコミット

**Step 1: 全体確認**

```bash
# agents 一覧
ls /home/eiji/works/its_my_turn/.claude/agents/

# 各エージェントの tools: 確認
grep "^tools:" /home/eiji/works/its_my_turn/.claude/agents/*.md

# Notion 参照が残っていないか確認
grep -r "notion" /home/eiji/works/its_my_turn/.claude/agents/ --include="*.md" -i | grep -v "^Binary"
grep -r "notion" /home/eiji/works/its_my_turn/CLAUDE.md -i
```

Expected:
- `notion-technical-writer.md` が存在しない
- `tools:` に `mcp__plugin_Notion` や `mcp__plugin_slack` が含まれていない
- CLAUDE.md に Notion 参照がない

**Step 2: git status 確認**

```bash
git -C /home/eiji/works/its_my_turn status
```

Expected: working tree clean（すべてコミット済み）
