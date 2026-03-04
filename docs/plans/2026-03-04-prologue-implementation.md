# プロローグ章の追加 実装計画

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** `docs/curriculum/chapter-prologue.md` を新規作成し、`index.md` にプロローグの行を追加する

**Architecture:** writerエージェントが `chapter-prologue.md` を作成し、続けて `index.md` を更新する。いずれも `docs/` 以下なのでサブエージェントに委譲する。

**Tech Stack:** Markdown、writerエージェント

---

### Task 1: `chapter-prologue.md` を作成する

**Files:**
- Create: `docs/curriculum/chapter-prologue.md`

**Step 1: writerエージェントで章を作成する**

writerエージェントに以下の仕様で `docs/curriculum/chapter-prologue.md` を作成させる。

**ファイルの完全な仕様:**

```text
# プロローグ: 今日から私は

> **この資料について**: カリキュラムを始める前に読んでおく読み物です。ハンズオン当日までに目を通しておいてください。

---

## このカリキュラムについて

（このカリキュラムの目的・対象者・何を作るかの短い案内。2〜3段落程度）

---

## 生成AIの次のステップ

### 処理の中にAIを組み込む

（従来のAI活用の説明。PDFの文章をベースに、非エンジニア向けに平易にリライト）

### AIを使ってソリッドなものを作る

（Claude Codeに代表される新しいアプローチの説明。「AIを開発者の代行として活用し、決定論的で堅牢なソフトウェアそのものを構築する」というポイントを非エンジニア向けに説明）

### 誰がこのスキルを習得すべきか

（「ビジネスの課題を肌で理解している人間が、自ら解決手段を構築できる」という点を非エンジニア向けに説明）

---

## 開発環境・お作法を理解しよう

（「急がば回れ。概念さえ分かればコマンドが分からなくても大丈夫」という方針の説明）

学習の進め方：

1. YouTube で動画を観る
2. Web ページを読む
3. NotebookLM に取り込んで、QA を出してもらう

---

## 事前に学習しておくこと

### 認証・認可と MCP

（この概念の重要性を1〜2文で説明）

- https://youtu.be/bFdWK6yKNHE?si=2aKOW_hmXVBT5UQc
- https://youtu.be/9sHOEDrHceo?si=qLXa3CGmLewIdky5

### Git / GitHub

（Gitの重要性を1〜2文で説明）

- https://youtu.be/LDOR5HfI_sQ?si=7Fk-xOXzeokFn4d2
- https://www.creativevillage.ne.jp/category/topcreators/web-creator/webprogrammer/128504/

### Pull Request & Review

（Pull Requestの重要性を1〜2文で説明。「ぷるりく」という呼び方を添える）

- https://www.youtube.com/watch?v=zeX2KASkOXY
- https://youtu.be/euK7YazfN3w?si=AQolTtOoYHHYa6lh
- https://qiita.com/obscure723/items/5265556d1b89e77c456b

### Claude Code Tips

（Claude Codeの公式ドキュメントとベストプラクティスへの案内）

- https://code.claude.com/docs/ja/overview
- https://skills.sh/

---

準備ができたら **[Chapter 0: 環境準備](chapter-00-setup.md)** に進んでください。
```

文体・スタイル:

- 対象読者：非エンジニア（PM、デザイナー、ビジネス職）
- 専門用語には初出時に平易な説明を添える
- 「結論 → たとえ話 → 詳細 → まとめ」を基本構成とする
- 丁寧かつ親しみやすいトーン
- コードブロックなし（読み物）
- 日本語で書く

**Step 2: ファイルが作成されたか確認する**

`docs/curriculum/chapter-prologue.md` が存在することを確認する。

**Step 3: コミット**

```bash
git add docs/curriculum/chapter-prologue.md
git commit -m "docs: プロローグ章を追加"
```

---

### Task 2: `index.md` にプロローグの行を追加する

**Files:**
- Modify: `docs/curriculum/index.md`

**Step 1: 現在の index.md を確認する**

`docs/curriculum/index.md` を読んで現在の表の構造を確認する。

**Step 2: writerエージェントで index.md を更新する**

現在の表:

```markdown
| # | チャプター | 所要時間 |
|---|-----------|---------|
| 0 | [環境準備](chapter-00-setup.md) | 約 1 時間 |
...
```

更新後の表（先頭にプロローグ行を追加）:

```markdown
| # | チャプター | 備考 |
|---|-----------|------|
| - | [プロローグ: 今日から私は](chapter-prologue.md) | 事前読み物 |
| 0 | [環境準備](chapter-00-setup.md) | 約 1 時間 |
...
```

ヘッダーの「所要時間」を「備考」に変更し、プロローグ行を先頭に追加する。

**Step 3: コミット**

```bash
git add docs/curriculum/index.md
git commit -m "docs: index にプロローグを追加"
```
