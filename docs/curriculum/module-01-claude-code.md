---
title: "Module 1: Claude Code を整える"
parent: カリキュラム
nav_order: 1
---

# Module 1: Claude Code を整える

**所要時間**: 約 1 時間
**ゴール**: CLAUDE.md、エージェントチーム、MCP サーバー、Slack Hook が稼働している状態
**学ぶ Claude Code 機能**: CLAUDE.md / Hooks / Agents / MCP

---

## このモジュールで学ぶこと

- CLAUDE.md を書いてプロジェクトのルールを Claude Code に伝える方法
- MCP サーバー（Slack・Figma）を接続して外部ツールを操作できるようにする方法
- 役割の異なるエージェントを作ってチームとして働かせる方法
- Slack Hook を設定してタスク完了を自動通知する方法

---

Claude Code はインストールしただけでは「何も知らない新しいアシスタント」の状態です。

このモジュールでは、Claude Code に以下の 4 つを設定します。

| 設定すること | たとえ話 | 効果 |
|------------|--------|------|
| **CLAUDE.md を書く** | 新しいアシスタントへの引き継ぎメモ | プロジェクトのルールを毎回説明しなくて済む |
| **MCP サーバーを接続する** | スマホにアプリを追加する | Slack や Figma を直接操作できるようになる |
| **エージェントチームを作る** | 専門分野が異なるチームメンバーを用意する | 役割に応じた的確なサポートが受けられる |
| **Slack Hook を設定する** | 完了を知らせる自動アラーム | 作業完了時に Slack へ自動通知が届く |

1 時間後には、あなたのプロジェクト専用に調整された AI 開発環境が整います。

---

## Step 1: CLAUDE.md を書く（15分）

### CLAUDE.md とは何か

CLAUDE.md（クロード・エムディー）は Claude Code が作業を始める前に必ず読む「引き継ぎメモ」です。

たとえるなら、新しく入ってきたアシスタントへの「業務マニュアル」です。

- 「このプロジェクトは TODO アプリを作っているよ」
- 「main というブランチに直接変更を保存してはいけない」
- 「TypeScript という言語を使っているよ」

こういった指示を一度書いておけば、毎回同じことを説明しなくて済みます。Claude Code は CLAUDE.md の内容をすべての作業で常に参照します。

### 1-1. Claude Code を起動する

プロジェクトのルートディレクトリ（作業フォルダのトップ）でターミナルを開き、以下のコマンドを入力します。

> **ルートディレクトリとは?** プロジェクトの一番上のフォルダのことです。`cd プロジェクト名` で移動できます。

```bash
claude
```

[screenshot: ターミナルで `claude` を入力してインタラクティブモードが起動した画面]

Claude Code のプロンプト（`>` や `?` の入力待ち記号）が表示されれば起動成功です。

### 1-2. `/init` コマンドで CLAUDE.md を自動生成する

Claude Code のプロンプトに以下のコマンドを入力します。

```
/init
```

> **`/init` って何?** Claude Code に「このプロジェクトの引き継ぎメモのたたき台を作って」と指示するコマンドです。Claude Code がプロジェクトのファイルを自動的にスキャンし、CLAUDE.md の雛形を生成してくれます。

[screenshot: `/init` 実行後に CLAUDE.md が生成された様子]

> **注意:** プロジェクトがまだ空の状態（ファイルが何もない）でも `/init` は実行できます。その場合は最小限の雛形が生成されます。

### 1-3. CLAUDE.md に内容を追記する

生成された CLAUDE.md をテキストエディタで開き、以下の内容を追記・編集します。

> **体験ポイント:** まずは何も書かずに Claude Code に「このプロジェクトは何のためのアプリですか？」と聞いてみましょう。答えが曖昧なことに気づくはずです。CLAUDE.md を書いた後で同じ質問をすると、明確な答えが返ってきます。これが「引き継ぎメモ」の効果です。

**完成形の CLAUDE.md（コピーして使ってください）:**

```markdown
# CLAUDE.md

このファイルは Claude Code がプロジェクト作業時に参照する説明書です。

## プロジェクト概要

TODO アプリ。ユーザーがタスクを追加・完了・削除できる Web アプリケーション。
非エンジニアが Claude Code の使い方を学ぶためのデモプロジェクトでもある。

## 技術スタック

- **フレームワーク**: Next.js（App Router）
- **スタイリング**: Tailwind CSS
- **データベース / 認証**: Supabase
- **ホスティング**: Vercel
- **言語**: TypeScript

## ディレクトリ構成

src/
  app/          # App Router のページ・レイアウト
  components/   # 再利用可能な UI コンポーネント
  lib/          # Supabase クライアントなどのユーティリティ

## Git ルール（MUST）

- **main ブランチでの commit / push は絶対禁止**
- 作業前に必ず `git branch --show-current` でブランチを確認すること
- main にいた場合はブランチ作成を提案して作業を止めること
- ブランチ命名規則:
  - 新機能: `feature/機能名`
  - バグ修正: `fix/修正内容`
  - リファクタリング: `refactor/内容`
  - ドキュメント: `docs/内容`
- コミットメッセージは Conventional Commits 形式を使う
  - 例: `feat: TODO 追加機能を実装`
  - 例: `fix: ログイン画面のバリデーションエラーを修正`

## コーディングルール

- TypeScript の型を省略しない（`any` は使わない）
- コンポーネントは `src/components/` に分割する
- Supabase の操作は `src/lib/` にまとめる
- コメントは日本語で書く
- エラーハンドリングを省略しない

## 開発サーバー

- 起動コマンド: `npm run dev`
- ポート: http://localhost:3000
- **開発サーバーの起動は Claude Code に任せず、手動で行うこと**

## コミット前チェック

コミットする前に必ず以下を確認する:
1. `npm run lint` でエラーがないこと
2. `npm run build` がエラーなく完了すること
```

### 1-4. 確認する

CLAUDE.md を保存したら、Claude Code のプロンプトで以下の質問を入力して変化を確認します。

```
このプロジェクトは何のためのアプリですか？使っている技術を教えてください。
```

[screenshot: CLAUDE.md 記載後に Claude Code が的確な回答を返している画面]

> **体験ポイント:** CLAUDE.md 追記前の回答と比べてみましょう。答えの具体性がまったく違うはずです。「引き継ぎメモ」を渡す前と後で、アシスタントの答えがどう変わるかを実感できます。

### Step 1 の確認ポイント

- [ ] `claude` コマンドで Claude Code が起動できる
- [ ] プロジェクトルートに `CLAUDE.md` ファイルが存在する
- [ ] Claude Code に「このプロジェクトの技術スタックは？」と聞いて、Next.js / Supabase / Vercel が含まれた回答が返ってくる
- [ ] Claude Code に「main ブランチにコミットしてください」と頼んだとき、警告が出るか確認する

---

## Step 2: MCP サーバーの設定（15分）

### MCP（Model Context Protocol）とは何か

MCP（エムシーピー）は、Claude Code に「外部ツールを操作する能力」を追加する仕組みです。

> **スマホのアプリに似ています。** Claude Code はスマートフォン本体、MCP サーバーはアプリです。スマホを買ったばかりのときは電話とカメラしか使えませんが、アプリを追加するほどできることが増えますよね。それと同じです。

普通の Claude Code は Slack を読んだり書いたりできません。しかし Slack の MCP サーバーを追加すると、Claude Code が Slack に直接メッセージを送れるようになります。同様に、Figma の MCP サーバーを追加すると Figma のデザインデータを読み書きできるようになります。

> **MCP（Model Context Protocol）をひとことで説明すると:** AI（Claude Code）と外部ツール（Slack、Figma など）を接続するための「共通規格」です。プラグのコンセント規格が統一されているおかげで様々な機器を差し込めるのと同じイメージです。

### 2-1. Slack MCP サーバーの接続

**事前準備: Slack ワークスペースの用意**

> **Slack ワークスペースとは?** チームで使う Slack の「部屋」のようなものです。会社や組織ごとに持っているものです。

1. Slack ワークスペースに参加済みであることを確認します
2. Slack の管理画面（https://api.slack.com/apps）にアクセスします
3. 「Create New App」→「From scratch」を選択します
4. App Name に `Claude Code Bot` などと入力し、ワークスペースを選択して作成します

[screenshot: Slack API アプリ作成画面]

5. 左メニューの「OAuth & Permissions」を開き、「Bot Token Scopes」に以下のスコープを追加します:
   - `channels:history`（チャンネルの過去メッセージを読む権限）
   - `channels:read`（チャンネルの情報を読む権限）
   - `chat:write`（メッセージを送信する権限）
   - `users:read`（ユーザー情報を読む権限）

6. 「Install to Workspace」ボタンをクリックし、ボットトークン（`xoxb-` で始まる文字列）をコピーします

> **ボットトークンとは?** Slack API を使うための「合言葉」です。この文字列があれば、プログラムが Slack に代わりにメッセージを送ったりできます。

[screenshot: Slack のボットトークンが表示されている画面]

> **注意:** ボットトークンは外部に漏らさないようにしてください。`.env` ファイル（設定値を書く環境変数ファイル）に保存し、Git にコミットしないことが重要です。

### 2-2. Figma MCP サーバーの接続

**Figma Personal Access Token の取得方法**

> **Figma（フィグマ）とは?** デザイナーが画面のデザインを作るためのツールです。このカリキュラムでは Module 3 で Figma と Claude Code を連携させて、「デザインを指定するだけでコードを自動生成する」体験をします。

> **Personal Access Token（パーソナル アクセス トークン）とは?** あなたが Figma にログインしているのと同等の権限を、プログラムに与えるための「合言葉」です。

1. Figma にログインし、画面右上のアカウントアイコンをクリックします
2. 「Settings」を選択します
3. 「Security」タブを開きます
4. 「Personal access tokens」セクションで「Generate new token」をクリックします
5. トークン名（例: `claude-code-token`）を入力し、有効期限を選択して作成します
6. 表示されたトークン（`figd_` で始まる文字列）をコピーします

[screenshot: Figma の Personal Access Token 生成画面]

> **注意:** トークンは一度しか表示されません。必ずコピーして安全な場所に保存してください。

### 2-3. `.claude/settings.json` を作成する

プロジェクトルートに `.claude/`（ドットクロード）ディレクトリを作成し、`settings.json` ファイルを以下の内容で作成します。

> **`.claude/` ディレクトリとは?** Claude Code の設定ファイルを置くフォルダです。先頭にドット（`.`）がつくフォルダは「隠しフォルダ」といって、通常は Finder やエクスプローラーに表示されません。

```bash
mkdir -p .claude
```

**`.claude/settings.json` の完全な内容:**

```json
{
  "mcpServers": {
    "slack": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-slack"
      ],
      "env": {
        "SLACK_BOT_TOKEN": "xoxb-ここにボットトークンを貼り付ける",
        "SLACK_TEAM_ID": "ここにワークスペースのチームIDを貼り付ける"
      }
    },
    "figma": {
      "command": "npx",
      "args": [
        "-y",
        "figma-developer-mcp",
        "--figma-api-key=ここにFigmaトークンを貼り付ける",
        "--stdio"
      ]
    }
  }
}
```

> **JSON（ジェイソン）とは?** コンピュータが読みやすい形式でデータを書く「書き方のルール」です。`{` と `}` で囲まれた部分が一つのかたまりで、`"キー": "値"` という形式でデータを表現します。

> **注意:** `xoxb-ここに...` の部分を実際のトークンに書き換えてください。このファイルは `.gitignore`（Git に登録しないファイルの一覧）に追加して、トークンが外部に漏れないようにしてください。

**`.gitignore` にシークレット設定ファイルを追加します。**

```bash
echo ".claude/settings.json" >> .gitignore
```

> **`.gitignore` とは?** 「このファイルは Git の管理対象に含めないで」という指示書です。パスワードや API Key が入ったファイルは必ずここに書いておきます。

### 2-4. 動作確認

Claude Code を再起動して MCP サーバーが読み込まれているか確認します。

```bash
# 一度 Claude Code を終了（Ctrl+C または /exit）して再起動
claude
```

Claude Code のプロンプトで以下のように試します。

**Slack の確認:**
```
Slack の #general チャンネルの最新メッセージを3件取得してください
```

**Figma の確認:**
（Figma のファイル URL を手元に用意してから）
```
このFigmaファイルの内容を取得してください: https://www.figma.com/file/XXXXXXXX/ファイル名
```

[screenshot: Claude Code が Slack のメッセージを取得している様子]

### Step 2 の確認ポイント

- [ ] `.claude/settings.json` が作成されている
- [ ] Claude Code を再起動したときにエラーが出ない
- [ ] Slack からメッセージを取得できる
- [ ] Figma のファイル内容を読み取れる（Figma ファイルが用意できている場合）
- [ ] `.gitignore` に `.claude/settings.json` が追加されている

---

## Step 3: エージェントチーム構築（20分）

### エージェントとは何か

エージェント（Agent）は、特定の専門知識や役割を持つ「Claude Code のチームメンバー」です。

> **チームワークのたとえで考えてみましょう。** 一人の人間が「エンジニアとしてコードを書き、ライターとして記事を書き、デザイナーとして画面を作る」のは難しいですよね。専門分野の違うメンバーを揃えた方が、仕事の質が上がります。エージェントはまさにそれです。

たとえば:
- 技術的なことに詳しい **エンジニアエージェント**
- わかりやすい文章を書く **ライターエージェント**
- 全体を見てジャッジする **編集長エージェント**

これらのエージェントを用意しておくと、「エンジニアに技術的な説明をしてもらって、それをライターがわかりやすく書き直して、編集長が最終チェックする」という流れを Claude Code が自動でこなせるようになります。

> **もう少し具体的に:** エージェントは `.claude/agents/` というフォルダに置くマークダウンファイル（`.md` ファイル）です。「このエージェントはどんな役割で、どんな口調で答えるか」を書いておくと、その通りの専門家として振る舞ってくれます。

### 3-1. エージェント用ディレクトリを作成する

```bash
mkdir -p .claude/agents
```

### 3-2. claude-code-expert エージェントを作成する

`.claude/agents/claude-code-expert.md` を以下の内容で作成します。このエージェントは「Claude Code の専門家」として振る舞います。

```markdown
---
name: claude-code-expert
description: Claude Code の機能・設定・ベストプラクティスの専門家。CLAUDE.md の書き方、Hooks の設定、エージェントの設計、MCP サーバーの接続方法について詳しい。技術的に正確な情報を提供することを最優先とする。
tools:
  - read
  - write
  - bash
  - glob
  - grep
---

あなたは Claude Code の専門家です。

## 役割

Claude Code の全機能について深い知識を持ち、以下の領域で正確な情報を提供します:

- CLAUDE.md の効果的な書き方と設定例
- Hooks（PreToolUse / PostToolUse / Notification / Stop）の設定と活用
- Custom Agents の設計と `.claude/agents/` への配置方法
- MCP サーバーの接続・設定・トラブルシューティング
- Claude Code CLI のオプションとフラグ（`-p`, `--model`, `--resume` など）
- コスト最適化とコンテキストウィンドウ管理

## 行動指針

- 技術的な正確性を最優先にする
- 設定例はそのままコピーして使えるレベルで提供する
- 不確かな情報は「不確かです」と明示する
- コードブロックを積極的に使い、具体的な例を示す
- 日本語で回答する

## 注意事項

- 開発サーバー（`npm run dev`）は起動しない
- 破壊的な操作（`git reset --hard`、ファイル削除など）は事前に確認する
```

### 3-3. notion-technical-writer エージェントを作成する

`.claude/agents/notion-technical-writer.md` を以下の内容で作成します。このエージェントは「Notion（ノーション）への出力担当」として振る舞います。

> **Notion とは?** ドキュメント作成・管理ツールです。このカリキュラムでは Notion に作業内容やドキュメントを保存することがあります。

```markdown
---
name: notion-technical-writer
description: 技術コンテンツを Notion に出力する専門家。Notion MCP を使った構造化されたページ作成、データベース設計、チェックリストやコールアウトを活用したわかりやすいドキュメント構成が得意。claude-code-expert や tech-editor-chief が作ったコンテンツを最終的に Notion へ出力する役割を担う。
tools:
  - read
  - write
  - mcp__Notion__search
  - mcp__Notion__fetch
  - mcp__Notion__create-pages
  - mcp__Notion__update-page
  - mcp__Notion__create-database
---

あなたは Notion 専門のテクニカルライターです。

## 役割

技術コンテンツを Notion に最適化された形で出力することが専門です:

- Notion のブロック構造（見出し、コールアウト、トグル、チェックリスト）を活用する
- データベースのプロパティ設計（Status、Due Date、Tag など）
- コードブロックには適切な言語を指定する
- スクリーンショット挿入位置を `[screenshot: 説明]` で明示する

## 行動指針

- 最終的な読者（非エンジニア）が迷わない構成を心がける
- 情報量が多い場合はトグルブロックで折りたたむ
- 重要な注意点は必ずコールアウトブロックを使う
- チェックボックスを積極的に使い、完了確認しやすくする
- 日本語で回答・出力する

## Notion 出力時の形式

- コードは必ずコードブロック（言語指定あり）
- 警告は ⚠️ コールアウト
- 体験・気づきポイントは 💡 コールアウト
- 手順は番号付きリスト
- 確認事項はチェックボックス
```

### 3-4. tech-editor-chief エージェントを作成する

`.claude/agents/tech-editor-chief.md` を以下の内容で作成します。このエージェントは「非エンジニア向けの編集長」として振る舞います。

```markdown
---
name: tech-editor-chief
description: 技術コンテンツを非エンジニアにわかりやすく翻訳する編集長。claude-code-expert が書いた技術的なドラフトを受け取り、専門用語をかみ砕いて説明し、日常生活のたとえを加え、「なぜこの設定が必要か」の背景を補足する。読み手が迷わないようにすることを最優先とする。
tools:
  - read
  - write
---

あなたは非エンジニア向けの技術コンテンツを専門とする編集長です。

## 役割

技術者が書いたドラフトを、PC 操作に慣れた非エンジニアが読んでも迷わない文章に書き換えます:

- 専門用語（MCP、Hook、API、CLI など）には初出時に日常語での説明を追加する
- 「なぜこの設定が必要か」という背景・理由を各ステップに追加する
- 日常生活のたとえを使って概念をわかりやすく伝える
- 長い手順は「まずこれだけやれば OK」という要約から始める
- エラーや躓きやすいポイントには「うまくいかない場合は」セクションを追加する

## 行動指針

- 読者は「ターミナルは少し使える」「プログラミング経験はない」を前提とする
- 「エンジニアが当たり前と思っていること」を丁寧に説明する
- 難しい概念は削るのではなく、わかりやすく伝える
- 手順の前に「このステップで何をするか」を 1 文で説明する
- 日本語で回答する

## リライト時のチェックリスト

- [ ] 専門用語すべてに説明があるか
- [ ] 各ステップに「なぜやるか」が書かれているか
- [ ] たとえ話や図解の説明があるか
- [ ] エラー対処の説明があるか
- [ ] 非エンジニアの友人に読ませて理解できそうか
```

### 3-5. エージェントへの呼びかけデモ

Claude Code のプロンプトで以下のように試してみましょう。エージェントを使う/使わないで回答のトーンや内容がどう変わるか体感してください。

**例 1: claude-code-expert に質問する**
```
claude-code-expert として、CLAUDE.md に Git ルールを追加するベストプラクティスを教えてください
```

**例 2: tech-editor-chief にリライトを依頼する**
```
tech-editor-chief として、以下の技術説明を非エンジニア向けにわかりやすく書き直してください:

「MCP（Model Context Protocol）は、LLM と外部ツールをつなぐ標準プロトコルです。stdio または SSE トランスポートを介して通信し、ツールの定義はスキーマで記述されます」
```

> **LLM（エルエルエム）とは?** Large Language Model（大規模言語モデル）の略で、Claude や ChatGPT などの AI のことです。

**例 3: エージェントに連携作業を依頼する**
```
以下のタスクを進めてください:
1. claude-code-expert が「Supabase の接続設定の手順」を技術的に正確に書く
2. tech-editor-chief がそれを非エンジニア向けにリライトする
3. notion-technical-writer が最終版を docs/curriculum/supabase-setup-draft.md に保存する
```

[screenshot: エージェントが連携してタスクをこなしている様子]

> **体験ポイント:** エージェントを使わずに同じ依頼をした場合と比べてみましょう。エージェントを指定すると、役割に応じた文体・視点で回答が変わることに気づくはずです。

### Step 3 の確認ポイント

- [ ] `.claude/agents/` ディレクトリが作成されている
- [ ] `claude-code-expert.md` が存在する
- [ ] `notion-technical-writer.md` が存在する
- [ ] `tech-editor-chief.md` が存在する
- [ ] Claude Code のプロンプトでエージェント名を指定して呼び出せる
- [ ] エージェントごとに返答のトーンや内容が変わることを確認できる

---

## Step 4: Slack Hook 設定（10分）

### Hooks とは何か

Hooks（フックス）は「Claude Code が特定の操作をしたときに、自動で何かを実行する」仕組みです。

> **工場の自動アラームのようなものです。** 製造ラインで作業が完了したら自動でブザーが鳴る、その Slack 版です。「Claude Code がタスクを完了したら、Slack に通知を送る」という動作を自動化できます。毎回手動で「終わったよ」とメッセージを送る手間がなくなります。

Claude Code に長い作業（ファイルを何十個も書くなど）をさせる場合、画面に貼り付いて見ていないといけないことがあります。Hooks を設定しておけば、作業から離れていても完了したら通知が来るので安心です。

> **Hook の種類（参考）:**
> - `Stop`（ストップ）: Claude が返答を終了するとき
> - `PreToolUse`（プリ ツール ユース）: ツール実行前
> - `PostToolUse`（ポスト ツール ユース）: ツール実行後
> - `Notification`（ノティフィケーション）: 通知が必要なとき

### 4-1. 通知スクリプトを作成する

`.claude/hooks/`（ドットクロード スラッシュ フックス）ディレクトリを作成し、通知スクリプトを配置します。

```bash
mkdir -p .claude/hooks
```

`.claude/hooks/notify-slack.sh` を以下の内容で作成します。

> **`.sh` ファイルとは?** シェルスクリプトと呼ばれる、ターミナルで実行するプログラムです。「このスクリプトを実行したら Slack に通知を送る」という手順が書かれています。

```bash
#!/bin/bash
# Claude Code のタスク完了時に Slack に通知するスクリプト
#
# 入力: stdin から JSON を受け取る
# 例: {"type":"Stop","message":"タスクが完了しました"}

# 設定（環境変数またはここに直接記入）
SLACK_WEBHOOK_URL="${SLACK_WEBHOOK_URL:-https://hooks.slack.com/services/ここにWebhookURLを貼り付ける}"
CHANNEL="${SLACK_CHANNEL:-#claude-code-notifications}"

# stdin から JSON を読み込む
INPUT=$(cat)

# 終了理由とメッセージを取得する
STOP_REASON=$(echo "$INPUT" | grep -o '"stop_reason":"[^"]*"' | cut -d'"' -f4)
MESSAGE=$(echo "$INPUT" | grep -o '"message":"[^"]*"' | cut -d'"' -f4 | head -1)

# メッセージが空の場合はデフォルトメッセージを使う
if [ -z "$MESSAGE" ]; then
  MESSAGE="Claude Code がタスクを完了しました"
fi

# Slack Incoming Webhook で通知を送信する
curl -s -X POST "$SLACK_WEBHOOK_URL" \
  -H 'Content-type: application/json' \
  --data "{
    \"channel\": \"$CHANNEL\",
    \"username\": \"Claude Code\",
    \"icon_emoji\": \":robot_face:\",
    \"text\": \"*[Claude Code 完了通知]* $MESSAGE\",
    \"attachments\": [
      {
        \"color\": \"good\",
        \"fields\": [
          {
            \"title\": \"終了理由\",
            \"value\": \"${STOP_REASON:-task_complete}\",
            \"short\": true
          },
          {
            \"title\": \"時刻\",
            \"value\": \"$(date '+%Y-%m-%d %H:%M:%S')\",
            \"short\": true
          }
        ]
      }
    ]
  }"

echo "Slack notification sent."
```

スクリプトに実行権限を付与します。

```bash
chmod +x .claude/hooks/notify-slack.sh
```

> **`chmod +x` とは?** ファイルを「実行可能」にするコマンドです。スクリプトファイルはこの権限がないとターミナルから実行できません。`chmod` は「change mode（変更モード）」の略です。

### 4-2. Slack Incoming Webhook URL を取得する

> **Incoming Webhook（インカミング ウェブフック）とは?** Slack が提供する「外部のプログラムからメッセージを受け取るための専用 URL」です。この URL にデータを送ると、指定したチャンネルにメッセージが届きます。

1. Slack API ページ（https://api.slack.com/apps）で Step 2 で作ったアプリを開きます
2. 左メニュー「Incoming Webhooks」をクリックします
3. 「Activate Incoming Webhooks」をオンにします
4. 「Add New Webhook to Workspace」をクリックします
5. 通知を送りたいチャンネル（例: `#claude-code-notifications`）を選択します
6. 生成された Webhook URL（`https://hooks.slack.com/services/...`）をコピーします

[screenshot: Slack の Incoming Webhook URL が生成された画面]

### 4-3. `.claude/settings.json` に Hooks 設定を追加する

Step 2 で作成した `.claude/settings.json` を開き、`"hooks"` セクションを追加します。

**`.claude/settings.json` の完全な内容（更新版）:**

```json
{
  "mcpServers": {
    "slack": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-slack"
      ],
      "env": {
        "SLACK_BOT_TOKEN": "xoxb-ここにボットトークンを貼り付ける",
        "SLACK_TEAM_ID": "ここにワークスペースのチームIDを貼り付ける"
      }
    },
    "figma": {
      "command": "npx",
      "args": [
        "-y",
        "figma-developer-mcp",
        "--figma-api-key=ここにFigmaトークンを貼り付ける",
        "--stdio"
      ]
    }
  },
  "hooks": {
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "/bin/bash /home/あなたのユーザー名/workspace/プロジェクト名/.claude/hooks/notify-slack.sh"
          }
        ]
      }
    ]
  }
}
```

> **注意:** `command` のパスは「絶対パス」（ルートディレクトリからの完全なパス）で指定する必要があります。`/home/あなたのユーザー名/...` の部分を実際のパスに書き換えてください。ターミナルで `pwd` コマンドを実行すると現在いるディレクトリの絶対パスが確認できます。

> **絶対パスとは?** ファイルの「住所」です。`/home/eiji/workspace/project/.claude/hooks/notify-slack.sh` のように、ルート（一番上のフォルダ）から順番にたどった場所を表します。

### 4-4. 動作確認

Claude Code を再起動し、簡単なタスクを実行して Slack に通知が来ることを確認します。

```bash
claude
```

プロンプトに以下を入力します。

```
「Hello, World!」という内容のテキストファイルを test-hello.txt という名前で作成してください。作成したら完了です。
```

[screenshot: Claude Code がタスクを完了した後、Slack に通知が届いている様子]

タスク完了後、Slack の指定チャンネルに通知が届いていれば成功です。

テスト用ファイルは削除しておきましょう。

```bash
rm test-hello.txt
```

> **体験ポイント:** Claude Code に長い作業（複数ファイルの作成など）を依頼して、PC から離れてみましょう。作業が終わると Slack に通知が来るので、画面を見張り続ける必要がなくなります。「作業を任せて、完了を待つ」という新しい開発スタイルを体感できます。

### Step 4 の確認ポイント

- [ ] `.claude/hooks/notify-slack.sh` が作成されている
- [ ] スクリプトに実行権限（`chmod +x`）が付与されている
- [ ] Slack Incoming Webhook URL を取得済み
- [ ] `.claude/settings.json` に `"hooks"` セクションが追加されている
- [ ] Claude Code でタスクを完了させたときに Slack に通知が届く

---

## Module 1 完了チェック

このモジュールを完了すると、以下の状態になっているはずです。

- [ ] **CLAUDE.md**: プロジェクト概要・技術スタック・Git ルール・コーディングルールが記載されている
- [ ] **MCP サーバー**: Slack MCP と Figma MCP が `.claude/settings.json` に設定されている
- [ ] **エージェントチーム**: 3 つのエージェント定義ファイルが `.claude/agents/` に配置されている
- [ ] **Slack Hook**: タスク完了時に Slack 通知が届く仕組みが稼働している

---

## ファイル構成（完了後）

```
プロジェクトルート/
├── CLAUDE.md                          # Claude Code への説明書（引き継ぎメモ）
├── .gitignore                         # .claude/settings.json を追加済み
└── .claude/
    ├── settings.json                  # MCP・Hooks 設定（Git に含めない）
    ├── agents/
    │   ├── claude-code-expert.md      # 技術専門家エージェント
    │   ├── notion-technical-writer.md # Notion ライターエージェント
    │   └── tech-editor-chief.md       # 編集長エージェント
    └── hooks/
        └── notify-slack.sh            # Slack 通知スクリプト
```

---

## うまくいかないときは

### Claude Code が起動しない

```bash
# インストールの確認
npm list -g @anthropic-ai/claude-code

# 再インストール
npm install -g @anthropic-ai/claude-code

# バージョン確認
claude --version
```

### MCP サーバーが接続できない

- `.claude/settings.json` の JSON 形式が正しいか確認する（カンマの過不足に注意。最後の項目にカンマをつけてはいけません）
- ターミナルで `npx -y @modelcontextprotocol/server-slack` を直接実行してエラーを確認する
- トークンに余分なスペースや改行が混入していないか確認する
- わからなければメンターに声をかけてください

### Slack 通知が届かない

- Webhook URL が正しいか確認する（`curl` コマンドで直接テストできます）
- スクリプトのパスが絶対パスになっているか確認する
- スクリプトに実行権限があるか `ls -la .claude/hooks/` で確認する

### エージェントが認識されない

- ファイル名が `.md` 拡張子になっているか確認する
- `.claude/agents/` の直下にファイルがあるか確認する（サブディレクトリ内には置けません）
- YAML フロントマター（`---` で囲まれた部分）の形式が正しいか確認する

> **YAML フロントマターとは?** ファイルの先頭に書く設定情報です。`---` で囲まれた中に、エージェントの名前や使えるツールなどを書きます。

---

## このモジュールのまとめ

このモジュールでは、Claude Code を「使えるツール」から「チームとして働ける環境」に整えました。

- **CLAUDE.md** でプロジェクトのルールを一度書けば、毎回説明しなくて済むようになりました
- **MCP サーバー**（Slack・Figma）を接続し、Claude Code から外部ツールを直接操作できるようになりました
- **エージェントチーム**（技術専門家・ライター・編集長）を作り、役割に応じた専門的なサポートを受けられるようになりました
- **Slack Hook** を設定し、Claude Code の作業完了を自動で通知できるようになりました

Module 1 で作った設定は、次の Module 2 以降で活きてきます。CLAUDE.md の Git ルールがブランチ管理を自動化し、エージェントが専門的な役割でサポートし、Slack Hook が作業完了を教えてくれます。

---

次のモジュールへ: [Module 2: プロジェクト初期化](./module-02-project-init.md)
