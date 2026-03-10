# Chapter 8: Vercel デプロイ

**所要時間**: 約 1 時間
**ゴール**: 公開 URL で TODO アプリが動いている状態にする
**学ぶ Claude Code 機能**: デプロイ支援、CI/CD 連携

---

## このチャプターで学ぶこと

- Vercel CLI でプロジェクトを作成し、GitHub リポジトリと連携する
- Vercel に環境変数を設定してデプロイを実行する
- 公開 URL でアプリの動作を確認する
- Supabase の本番用 URL 設定が必要なケースを理解する
- GitHub への push が自動デプロイにつながる仕組みを体験する

全部終わったら、インターネット上に公開された自分の TODO アプリが完成します。

---

Chapter 5 まででローカル環境（自分のパソコン）で動く TODO アプリが完成しました。このチャプターでは、それをインターネット上に公開します。

> [!NOTE]
> **デプロイ（deploy）とは？** 「展開する」「配備する」という意味の言葉です。IT の世界では「アプリをサーバーに乗せて、インターネット上で使えるようにすること」を指します。自分の部屋で作った料理をレストランで提供し始めるイメージです。

公開することで、以下のことが可能になります。

- 自分以外の人がブラウザでアクセスできるようになる
- スマートフォンからも使えるようになる
- 「作ったものを見せる」ことができるようになる

このチャプターで使う **Vercel（ヴァーセル）** は、Next.js アプリを最も手軽に公開できるホスティングサービスです。GitHub と連携することで、コードを push するだけで自動的に最新版がデプロイされる仕組みを構築します。

> [!NOTE]
> **ホスティングサービスとは？** アプリを動かし続けてくれるサーバーを貸してくれるサービスです。自分のパソコンを 24 時間稼働させなくても、Vercel のサーバーが代わりにアプリを動かし続けてくれます。
>
> **GitHub と連携すると何が嬉しいの？** コードを push（送信）するたびに Vercel が自動で新バージョンをデプロイしてくれます。「変更を保存してアップロードボタンを押す」という手間がなくなります。これを **CI/CD（継続的インテグレーション/継続的デリバリー）** と呼びます。

間違えても大丈夫です。途中でわからなくなったら、すぐメンターに声をかけてください。

---

## Step 1: Vercel 設定（20分）

このステップでは、GitHub リポジトリと Vercel を連携してデプロイの準備をします。

> [!NOTE]
> **Chapter 0 の確認:** 以下が完了していることを確認してください。完了していない場合は先に Chapter 0 の「Vercel アカウント + Vercel CLI」の手順を実施してください。
>
> - [ ] Vercel アカウントを作成済み
> - [ ] `vercel --version` でバージョン番号が表示される
> - [ ] `vercel login` でログイン済み

### 1-1. GitHub のリポジトリと Vercel を連携する

Chapter 1 で作成した GitHub リポジトリと Vercel を連携します。**メインブランチのターミナル**で、プロジェクトのルートディレクトリ（`todos/` フォルダ）に移動してから実行します。

```bash
# bash
vercel link
```

実行すると、いくつかの質問が対話形式で表示されます。以下のように答えてください。

| 表示される質問 | 答え方 |
|---|---|
| `Set up "~/works/todos"?` | `y` を入力して Enter |
| `Which scope should contain your project?` | ↑↓キーで自分のアカウント名を選んで Enter |
| `Link to existing project?` | `n` を入力して Enter（新規作成なので） |
| `What's your project's name?` | `todos` のまま Enter（または好みの名前） |
| `In which directory is your code located?` | `./` のまま Enter |
| `Want to modify these settings?` | `n` を入力して Enter |
| `Do you want to change additional project settings?` | `n` を入力して Enter |
| `Detected a repository. Connect it to this project?` | `y` を入力して Enter ← **ここが GitHub 連携の肝** |

最後に以下の 2 行が表示されれば成功です。

```text
# output
✅  Linked to your-account/todos (created .vercel)
> Connecting GitHub repository: https://github.com/あなたのユーザー名/todos
```

> [!IMPORTANT]
> **「Connecting GitHub repository」が大事な理由:** ここで GitHub リポジトリと Vercel が結びつくことで、今後 `git push` するたびに Vercel が自動で最新版をデプロイしてくれるようになります。「変更を保存してアップロードボタンを押す」という手間が永久になくなります。

> [!NOTE]
> **`.vercel/` フォルダについて:** `vercel link` を実行すると `.vercel/` というフォルダが作られます。この中にプロジェクトの接続情報が保存されています。`.gitignore` に追加されているため Git には含まれません（他人に知られてはいけない情報が入っているためです）。

### Step 1 の確認ポイント

- [ ] `vercel link` を実行して `✅ Linked to ...` が表示されている
- [ ] `Connecting GitHub repository` が表示されて GitHub 連携が完了している

---

## Step 2: 環境変数 & デプロイ（20分）

このステップでは、Supabase の接続情報を Vercel に登録してからデプロイを実行します。

### なぜ環境変数が必要か

ローカル環境では `.env.local` ファイルに Supabase の URL とキーを保存していました。しかし `.env.local` は Git に含まれていないため、Vercel にはその情報が届きません。

Vercel の「環境変数」機能を使って、本番サーバーにも同じ情報を安全に設定する必要があります。

> [!NOTE]
> **環境変数って何？** アプリが動く「環境」ごとに変わる設定値のことです。「自分のパソコン」と「Vercel のサーバー」では環境が違うので、それぞれに別々に設定します。`.env.local` はメモ帳に書いた個人のメモ、Vercel の環境変数は会社の金庫に保管した公式な設定書類のイメージです。

### 2-1. 環境変数の値を確認する

まず、設定が必要な値を確認します。ターミナルで以下を実行してください。

```bash
# bash
cat .env.local
```

以下の 2 つの値が表示されます。

```text
# output
NEXT_PUBLIC_SUPABASE_URL=https://xxxxxxxxxxxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY=eyJhbGciO...（長い文字列）
```

> [!WARNING]
> **注意:** これらの値を第三者に教えないでください。特に `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` は公開 API キーですが、Supabase の RLS（Chapter 3 で設定したセキュリティ機能）が有効であれば安全に使用できます。

### 2-2. Vercel に環境変数を設定する

Claude Code を起動して、環境変数の設定を依頼します。**メインブランチのターミナル**で以下を実行してください。

```bash
# bash
claude
```

Claude Code が起動したら、以下のように入力します。

```plaintext
# claude
.env.local の値を読み取って、Vercel の本番環境（production）に環境変数を設定して
```

Claude Code が内部で以下のようなコマンドを実行します。

```bash
# bash
vercel env add NEXT_PUBLIC_SUPABASE_URL production
vercel env add NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY production
```

各コマンドを実行するたびに「値を入力してください」と求められます。Claude Code に依頼した場合は、`.env.local` を読み取って自動で値を入力まで行ってくれます。

> [!TIP]
> **自分で設定する場合:** Claude Code を使わず手動で実行することもできます。コマンドを実行するたびに、対応する値（`https://...` や `eyJ...` の長い文字列）を貼り付けて Enter を押してください。

### 2-3. ビルドを確認してデプロイする

環境変数の設定が完了したら、ビルドの確認とデプロイを Claude Code に依頼します。

> [!NOTE]
> **ビルドとは？** プログラムのソースコードを、サーバーで動かせる形式に変換する処理です。料理でいえば「レシピ（コード）をもとに実際の料理（動くアプリ）を作る」工程です。デプロイ前にビルドが通るかを確認しておくと、本番でエラーが起きるリスクを減らせます。

Claude Code に以下を入力してください。

```plaintext
# claude
デプロイ前にビルドが通るか確認して、問題がなければ vercel deploy --prod で本番デプロイして
```

Claude Code はまず `npm run build` でビルドが通るかを確認し、問題があれば修正してからデプロイを実行します。問題がなければそのまま本番デプロイまで進みます。

> [!NOTE]
> **`vercel deploy --prod` と `git push` の違い:**
>
> - `vercel deploy --prod`（CLI デプロイ）: ターミナルから直接デプロイします。初回デプロイや緊急の修正デプロイに使います。
> - `git push`（自動デプロイ）: GitHub に変更を push すると Vercel が自動で検知してデプロイします。日常の開発フローはこちらが中心になります。
>
> まずは CLI で初回デプロイを確認し、その後は `git push` による自動デプロイを使うのが標準的なフローです。

### 2-4. デプロイ結果を確認する

デプロイが完了すると、ターミナルに以下のような出力が表示されます。

```text
# output
✓ Build completed
✓ Deployment completed

Production: https://todos-xxxxxxxxxxxx.vercel.app
```

`Production:` の行に表示された URL が、あなたのアプリの公開 URL です。ブラウザで開いて動作を確認してください。

エラーが表示された場合は、「トラブルシューティング」を参照してください。

### Step 2 の確認ポイント

- [ ] Vercel のプロジェクト設定に 2 つの環境変数（`NEXT_PUBLIC_SUPABASE_URL`・`NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY`）が登録されている
- [ ] `vercel deploy --prod` が成功して `✓ Deployment completed` が表示されている
- [ ] 公開 URL（`https://プロジェクト名.vercel.app` のような形式）が発行されている

---

## Step 3: 本番動作確認 & 振り返り（20分）

このステップでは、公開されたアプリの動作を確認し、必要に応じて Supabase の設定を本番用に更新します。

### 3-1. 公開 URL でアプリを確認する

Step 2 で発行された公開 URL（`https://プロジェクト名.vercel.app`）をブラウザで開きます。

以下のチェックリストで動作を確認します。

- [ ] サインアップできる
- [ ] ログインできる
- [ ] TODO を追加できる
- [ ] TODO の一覧が表示される
- [ ] TODO を完了にできる
- [ ] TODO を削除できる
- [ ] ログアウトできる

> [!WARNING]
> **注意:** サインアップ後にメール確認が必要な場合があります。登録したメールアドレスに確認メールが届いていないか確認してください。確認メールのリンクが正しく機能しない場合は、Step 3-2 でメール確認用の本番 URL を設定してください。

### 3-2. Supabase の本番用 URL を設定する（必要な場合のみ）

メールとパスワードによるサインアップ・ログイン・データの読み書きは、この設定をしなくても本番環境で動作します。

ただし、以下のいずれかの機能を使う場合は設定が必要です。

- **メール確認（メールアドレス確認リンク）**: サインアップ時に確認メールを送り、リンクをクリックして本登録させる機能
- **パスワードリセット**: 「パスワードを忘れた」メールを送り、リンクから再設定させる機能

これらの機能を追加するときは、以下の手順で Supabase に本番 URL を登録してください。

> [!NOTE]
> **なぜ登録が必要なの？** メール内のリンクをクリックしたとき、Supabase はユーザーを「登録済みの URL」にしかリダイレクトできません。セキュリティのため、知らない URL に誘導されないよう制限されているからです。

1. Supabase ダッシュボード（`https://supabase.com/dashboard`）を開く
2. プロジェクトを選択する
3. 左メニューの「Authentication」をクリックする
4. 「URL Configuration」を選択する
5. 「Site URL」を本番 URL に更新する:

   ```text
   https://プロジェクト名.vercel.app
   ```

6. 「Redirect URLs」に以下を追加する（「Add URL」をクリック）:

   ```text
   https://プロジェクト名.vercel.app/**
   ```

7. 「Save」をクリックして保存する

> [!WARNING]
> **ローカル開発への影響:** Site URL を本番 URL に変更すると、ローカル環境（`localhost:3000`）でメール確認・パスワードリセットが機能しなくなります。Redirect URLs にローカルの URL も追加しておくと、両方の環境で動作します:
>
> ```text
> http://localhost:3000/**
> https://プロジェクト名.vercel.app/**
> ```

### 3-3. CI/CD の体験（自動デプロイ）

> [!NOTE]
> **CI/CD とは？** Continuous Integration / Continuous Delivery の略です。「コードを push すると自動でテスト・ビルド・デプロイが走る仕組み」のことです。注文（push）するだけで自動的に届けてくれるデリバリーサービスのイメージです。一度設定すれば、毎回手動でデプロイする必要がなくなります。

> [!WARNING]
> **事前確認: git の名前・メールアドレスが GitHub アカウントと一致しているか確認しましょう**
>
> Vercel の無償プランでは、「コミットした人の情報」が Vercel アカウントのオーナーと同一人物と判定されないと、自動デプロイがブロックされます。Claude Code がコミットを作成する場合も、git に設定された名前・メールアドレスが GitHub アカウントのものと一致していれば問題ありません。
>
> ターミナルで以下を実行して確認してください。
>
> ```bash
> # bash
> git config user.name
> git config user.email
> ```
>
> 表示された名前・メールアドレスが、GitHub アカウントの設定と一致していれば OK です。GitHub の名前・メールアドレスは `https://github.com/settings/profile` で確認できます。
>
> **ブロックされたときのサイン:** PR をマージしても Vercel ダッシュボードの「Deployments」でデプロイが始まらない場合は、この設定のずれが原因の可能性があります。その場合は `git config --global user.email "あなたのGitHubメールアドレス"` で設定を合わせてから、再度 push してみてください。

**Chapter 5 で学んだ「Issue → ワークツリー → 実装 → PR → マージ」のフローをもう一度やります。** ただし今回の目的は機能追加ではなく「PR をマージすると Vercel が自動でデプロイされる」という体験です。

#### Step 1: 小さな改善を Issue として登録する

Claude Code に以下のように依頼し、GitHub に Issue を立てます。題材は自分のアプリに合った小さな改善なら何でも構いません。

```plaintext
# claude
GitHub に Issue を立てて。タイトルは「ページタイトルをアプリ名に変更する」、内容は「ブラウザのタブに表示されるページタイトルが "Create Next App" のままなので、アプリ名に変更する。」にして
```

Issue が作成されると番号（例: `#3`）が発行されます。

> [!TIP]
> **こんな Issue でも OK:** 「ボタンのラベルをわかりやすくする」「ローディング中に表示を出す」「フォントを変える」など、動作に影響しない小さな改善が最初は向いています。

#### Step 2: ワークツリーで実装する

Chapter 5 と同じように `claude -w` でワークツリーを立ち上げ、Claude Code に実装を依頼します。詳細な手順は [Chapter 5: Step 2〜Step 4](chapter-05-git-workflow.md) を参照してください。

```bash
# bash
claude -w fix_page_title
```

別のターミナルを開いて、ワークツリーに移動し `.env.local` のショートカットを作成します。ワークツリーでアプリを動かして動作確認するために必要です。

```bash
# bash
cd .claude/worktrees/fix_page_title
ln -s ../../../.env.local .env.local
```

ワークツリーが起動したら、Issue の修正を依頼します。

```plaintext
# claude
Issue #3 の対応として、ページタイトルを「My Todos」に変更して
```

実装が完了したら、コミットします。

```plaintext
# claude
今の変更をコミットして。コミットメッセージは「fix: ページタイトルをアプリ名に変更する (#3)」にして
```

#### Step 3: PR を作成する

Chapter 5 と同じように PR を作成します。詳細な手順は [Chapter 5: Step 5](chapter-05-git-workflow.md) を参照してください。

```plaintext
# claude
ワークツリーの変更を push して、PR を作って。Issue #3 をクローズする形にして
```

#### Step 3.5: PR をレビューしてマージする

PR を作ったら、すぐマージするのではなく、まず「意図した通りの変更になっているか」を確認します。

レビューを Claude Code に依頼します。

```plaintext
# claude
PR をレビューして
```

Claude Code がレビュー結果を返してくれます。問題がなければマージします。

```plaintext
# claude
PR をマージして
```

> [!IMPORTANT]
> **新しい気づき:** Chapter 5 では「PR をマージすると Issue がクローズされる」ことを体験しました。今回はそれに加えて、「PR をマージするたびに Vercel が本番環境に自動デプロイされる」ことを体験します。これが CI/CD の感覚です。コードを送り出す（push → merge）だけで、本番のアプリが自動的に最新版になります。

#### Step 4: Vercel の自動デプロイを確認する

PR がマージされると、Vercel が自動でデプロイを開始します。

1. Vercel ダッシュボード（`https://vercel.com/dashboard`）をブラウザで開く
2. 対象プロジェクトをクリックする
3. 「Deployments」タブでデプロイが動いている様子を確認する（「Building...」や「Deploying...」と表示される）
4. 数分後に「Ready」と表示されたら、デプロイ完了

公開 URL を開いて、変更が反映されていることを確認してください。

---

### 振り返り: このカリキュラムで学んだ Claude Code 機能

| Chapter | 学んだ機能 |
|--------|-----------|
| 0 | CLI インストール、初期設定 |
| 1 | スキャフォールド、Git 操作 |
| 2 | CLAUDE.md、エージェント設定、MCP サーバー |
| 3 | DB 設計、SQL 生成（Supabase MCP） |
| 4 | 統合指示、Plan Mode、タスク分解 |
| 5 | Issue 管理、ワークツリー、PR レビュー |
| 6 | デプロイ支援、CI/CD、本番設定 |

**このカリキュラムで体験したこと:**

- Claude Code に日本語で自然な指示を出すだけでコードが書かれる
- CLAUDE.md にルールを書いておけば、毎回同じことを説明しなくてよい
- エージェントを使うと専門的な役割を持った AI チームメンバーが動く
- Git のブランチ管理も Claude Code が自動でチェックしてくれる
- デプロイまでの一連の流れを Claude Code がサポートしてくれる

> [!IMPORTANT]
> **体験まとめ:** 最初は「ターミナルに何を打てばいいかわからない」状態から始まりました。今では Claude Code に日本語で依頼するだけで、コードの作成・修正・テスト・デプロイまでをサポートしてもらえます。これが Claude Code を使った開発の第一歩です。

### Step 3 の確認ポイント

- [ ] 公開 URL でサインアップ・ログインができる
- [ ] 公開 URL で TODO の追加・一覧・完了・削除ができる
- [ ] 公開 URL でログアウトができる
- [ ] Supabase の Site URL と Redirect URLs を設定した（メール確認・パスワードリセット機能を使う場合のみ）
- [ ] Issue を立て、ワークツリーで実装し、PR をマージした
- [ ] PR マージ後に Vercel ダッシュボードで自動デプロイが走る様子を確認できた
- [ ] 公開 URL で PR の変更が反映されていることを確認できた

---

## チャプター全体の確認ポイント

このチャプターを完了すると、以下の状態になっているはずです。

- [ ] **Vercel デプロイ済み**: 公開 URL でアプリが動いている
- [ ] **環境変数設定済み**: Vercel に Supabase の接続情報が登録されている
- [ ] **CI/CD 構築済み**: GitHub への push で自動デプロイが動く
- [ ] **Supabase 本番設定**: 本番 URL でサインアップ・ログインができる（メール確認・パスワードリセットを使う場合は Site URL・Redirect URLs も設定済み）
- [ ] **全機能動作確認済み**: チェックリスト 7 項目がすべてクリア

---

## このチャプターで学んだこと

| 機能 | 体験した内容 |
|------|-------------|
| **デプロイ支援** | Claude Code に「ビルドを確認して本番デプロイして」と依頼するだけで、`npm run build` によるチェックから `vercel deploy --prod` による本番公開まで対応してもらえることを体験した |
| **環境変数設定** | ローカル用の `.env.local` に書いた Supabase の接続情報を `vercel env add` で Vercel にも登録し、本番サーバーでアプリが動く状態にした |
| **Supabase 本番設定** | 基本的な読み書き・ログインは設定なしで動作することを確認した。メール確認・パスワードリセット機能を追加する際は Site URL と Redirect URLs を設定する必要がある |
| **CI/CD 連携** | GitHub への push が Vercel の自動デプロイにつながる仕組みを構築し、「コードを push するだけで公開される」体験をした |

---

## カリキュラム完了

全 7 チャプター（Chapter 0〜6）が完了しました。

公開 URL を友人や同僚に共有して、自分で作った TODO アプリを使ってもらいましょう。

**次のステップとして、こんなことを試してみてください:**

- 機能を追加してみる（カテゴリ分け、期限設定、優先度など）
- デザインを変更してみる（Figma MCP サーバーを使って）
- 別のプロジェクトで同じ手順を試してみる

Claude Code は今後も継続的に機能が追加されています。公式ドキュメント（<https://docs.anthropic.com/en/docs/claude-code/overview>）を確認して、新しい機能を取り入れてみてください。

---

[← Chapter 7: Issue とワークツリー — 修正・改善を習慣にする](chapter-07-git-workflow.md)
