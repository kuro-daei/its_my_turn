# デザインドキュメント: プロローグ章の作成

作成日: 2026-03-04

## 概要

「今日から私は。Claude Code 編」カリキュラムに、既存の Chapter 0（環境準備）の前に置く**プロローグ章**を追加する。

プロローグは「読み物」として位置づけ、カリキュラムを始める前に読んでおく背景知識と事前学習リソースをまとめる。

## ファイル

| 種別 | パス |
|------|------|
| 新規作成 | `docs/curriculum/chapter-prologue.md` |
| 更新 | `docs/curriculum/index.md`（プロローグの行を追加） |

## chapter-prologue.md の構成

```text
# プロローグ: 今日から私は

## このカリキュラムについて
（カリキュラムの目的・対象者の短い案内）

## 生成AIの次のステップ

### 処理の中にAIを組み込む
（従来のAIアプローチの説明）

### AIを使ってソリッドなものを作る
（Claude Codeによる新しいアプローチ：AIを開発者の代行として活用）

### 誰がこのスキルを習得すべきか
（ビジネス課題を理解している人材が対象という説明）

## 開発環境・お作法を理解しよう
（急がば回れ。概念さえ分かればコマンドが分からなくても大丈夫という方針）
（学習方法：YouTube → Webページ → NotebookLM）

## 事前に学習しておくこと

### 認証・認可とMCP
（YouTubeリンク2本）

### Git / GitHub
（YouTubeリンクとWeb記事リンク）

### Pull Request & Review
（YouTubeリンク2本とQiita記事リンク）

### Claude Code Tips
（公式ドキュメントとベストプラクティスへのリンク）

---
Chapter 0（環境準備）に進む案内
```

## PDFから転記するリンク

以下のリンクをそのまま掲載する。

### 認証・認可とMCP

- <https://youtu.be/bFdWK6yKNHE?si=2aKOW_hmXVBT5UQc>
- <https://youtu.be/9sHOEDrHceo?si=qLXa3CGmLewIdky5>

### Git / GitHub

- <https://youtu.be/LDOR5HfI_sQ?si=7Fk-xOXzeokFn4d2>
- <https://www.creativevillage.ne.jp/category/topcreators/web-creator/webprogrammer/128504/>

### Pull Request & Review

- <https://www.youtube.com/watch?v=zeX2KASkOXY>
- <https://youtu.be/euK7YazfN3w?si=AQolTtOoYHHYa6lh>
- <https://qiita.com/obscure723/items/5265556d1b89e77c456b>

### Claude Code Tips

- <https://code.claude.com/docs/ja/overview>
- Claude Code のベストプラクティス（<https://skills.sh/>）

## index.md への追加内容

現在のチャプター表の先頭（Chapter 0 の上）に以下を追加する。

```text
| - | [プロローグ: 今日から私は](chapter-prologue.md) | 事前読み物 |
```

表のヘッダー行も「所要時間」から「備考」に変更が必要になる可能性があるため、表全体を確認してから編集すること。

## 文体・スタイルのガイドライン

| 項目 | 方針 |
|------|------|
| 対象読者 | 非エンジニア（PM、デザイナー、ビジネス職） |
| 文章構成 | 「結論 → たとえ話 → 詳細 → まとめ」を基本とする |
| 専門用語 | 初出時に平易な説明を添える |
| 言語 | 日本語 |
| コードブロック | なし（このページは読み物） |
| トーン | 丁寧かつ親しみやすい |

PDF の文章を参考にしつつ、カリキュラム全体のトーン（丁寧・親しみやすい）に合わせて書き直す。

## 作業メモ

- `docs/plans/` ディレクトリはこのファイルで新規作成
- プロローグはチャプター番号なし（`-`）で表示
- 「事前読み物」という位置づけなので、所要時間ではなく種別を示す表記にする
