# Module 7: Vercel デプロイ

**所要時間**: 約 1 時間
**ゴール**: 公開 URL で TODO アプリが動いている状態にする
**学ぶ Claude Code 機能**: CI/CD 連携、本番設定

---

## このモジュールで学ぶこと

- Vercel アカウントを作成し、Vercel CLI をインストールする
- GitHub にリポジトリを作成してコードを push する
- Vercel に環境変数を設定してデプロイを実行する
- 公開 URL でアプリの動作を確認する
- Supabase の本番用 URL を設定する
- GitHub への push が自動デプロイにつながる仕組みを体験する

全部終わったら、インターネット上に公開された自分の TODO アプリが完成します。

---

Module 6 まででローカル環境（自分のパソコン）で動く TODO アプリが完成しました。このモジュールでは、それをインターネット上に公開します。

> **デプロイ（deploy）とは？** 「展開する」「配備する」という意味の言葉です。IT の世界では「アプリをサーバーに乗せて、インターネット上で使えるようにすること」を指します。自分の部屋で作った料理をレストランで提供し始めるイメージです。

公開することで、以下のことが可能になります。

- 自分以外の人がブラウザでアクセスできるようになる
- スマートフォンからも使えるようになる
- 「作ったものを見せる」ことができるようになる

このモジュールで使う **Vercel（ヴァーセル）** は、Next.js アプリを最も手軽に公開できるホスティングサービスです。GitHub と連携することで、コードを push するだけで自動的に最新版がデプロイされる仕組みを構築します。

> **ホスティングサービスとは？** アプリを動かし続けてくれるサーバーを貸してくれるサービスです。自分のパソコンを 24 時間稼働させなくても、Vercel のサーバーが代わりにアプリを動かし続けてくれます。

> **GitHub と連携すると何が嬉しいの？** コードを push（送信）するたびに Vercel が自動で新バージョンをデプロイしてくれます。「変更を保存してアップロードボタンを押す」という手間がなくなります。これを **CI/CD（継続的インテグレーション/継続的デリバリー）** と呼びます。

間違えても大丈夫です。途中でわからなくなったら、すぐメンターに声をかけてください。

---

## 事前確認

作業を始める前に、現在のブランチを確認してください。

```bash
git branch --show-current
```

> **注意:** `main` と表示された場合は、作業を止めてブランチを作成してください。
> ```bash
> git checkout -b feature/vercel-deploy
> ```

---

## Step 1: Vercel 設定（20分）

このステップでは、Vercel アカウントを作り、アプリを公開する準備をします。

### 1-1. Vercel アカウントを作成する

1. ブラウザで `https://vercel.com` を開く
2. 右上の「Sign Up」をクリックする
3. 「Continue with GitHub」を選択する

[screenshot: Vercel のサインアップ画面で「Continue with GitHub」を選択している様子]

4. GitHub のアカウントでログインする（GitHub アカウントがない場合は先に `https://github.com` でアカウントを作成してください）
5. Vercel の利用規約に同意して、アカウントの作成を完了する

[screenshot: Vercel のダッシュボードにログインできた様子]

> **注意:** Vercel の無料プラン（Hobby）で、このカリキュラムの内容はすべて動作します。有料プランへのアップグレードを促すメッセージが表示されますが、スキップしてください。

### 1-2. Vercel CLI をインストールする

> **CLI（シーエルアイ）とは？** Command Line Interface の略で、「ターミナルで使うコマンド」のことです。Vercel CLI をインストールすると、ターミナルから `vercel` というコマンドでデプロイ操作ができるようになります。

> **注意:** このコマンドはターミナルで実行します。Claude Code のプロンプトではなく、通常のターミナル（または新しいターミナルウィンドウ）を使用してください。

```bash
npm i -g vercel
```

インストールが完了したか確認します。

```bash
vercel --version
```

バージョン番号（例: `39.x.x`）が表示されれば成功です。

> **注意:** `command not found` と表示された場合は、ターミナルを再起動してから再度確認してください。それでも解決しない場合はメンターに声をかけてください。

### 1-3. GitHub にリポジトリを作成する

Vercel は GitHub と連携して動作します。まず GitHub にリポジトリ（コードの保管場所）を作成します。

> **リポジトリとは？** コードとその変更履歴をまとめて保管する「コードの倉庫」です。GitHub はこの倉庫をインターネット上で管理してくれるサービスです。

**GitHub リポジトリがまだない場合:**

1. ブラウザで `https://github.com/new` を開く
2. 「Repository name」に `its_my_turn`（またはプロジェクト名）を入力する
3. Public または Private を選択する（どちらでも動作します）
4. 「Create repository」をクリックする

[screenshot: GitHub の新規リポジトリ作成画面]

5. 表示された URL（`https://github.com/あなたのユーザー名/its_my_turn.git`）をメモしておく

### 1-4. GitHub にコードを push する

Claude Code に以下のように依頼します。

> GitHub にコードを push する準備をして。リモートリポジトリの URL は `https://github.com/あなたのユーザー名/its_my_turn.git`

または、ターミナルで直接実行します。

```bash
# リモートリポジトリを登録する
git remote add origin https://github.com/あなたのユーザー名/its_my_turn.git

# 現在のブランチを確認する
git branch --show-current

# main ブランチに push する（初回のみ -u オプションが必要）
git push -u origin main
```

> **push とは？** ローカル（自分のパソコン）にあるコードを、GitHub のサーバー（リモート）に送信することです。手元で書いた原稿を出版社に送るイメージです。

> **注意:** `feature/vercel-deploy` ブランチで作業している場合は、先に main にマージしてから push するか、Vercel にはブランチを直接連携することもできます。メンターに確認してください。

[screenshot: ターミナルで git push が成功した様子]

### 1-5. Vercel と GitHub を連携する

1. Vercel ダッシュボード（`https://vercel.com/dashboard`）を開く
2. 「Add New Project」をクリックする

[screenshot: Vercel ダッシュボードの「Add New Project」ボタン]

3. 「Import Git Repository」のセクションに、先ほど作成した GitHub リポジトリが表示されているはずです
4. 「Import」をクリックする

[screenshot: Vercel のリポジトリ選択画面に GitHub リポジトリが表示されている様子]

5. プロジェクトの設定画面が表示される。現時点では「Deploy」ボタンは押さず、次のステップに進む

> **体験:** Claude Code に「Vercel にデプロイする準備をして」と依頼してみましょう。必要な手順や設定ファイルを確認してくれます。

> Vercel にデプロイする準備をして。環境変数に何を設定すればいいか教えて

### Step 1 の確認ポイント

- [ ] Vercel アカウントが作成できている
- [ ] `vercel --version` でバージョン番号が表示される
- [ ] GitHub にリポジトリが作成されている
- [ ] `git remote -v` でリモートリポジトリの URL が表示される
- [ ] `git push` が成功している
- [ ] Vercel ダッシュボードで GitHub リポジトリの Import 画面が開いている

---

## Step 2: 環境変数 & デプロイ（20分）

このステップでは、Supabase の接続情報を Vercel に登録してからデプロイを実行します。

### なぜ環境変数が必要か

ローカル環境では `.env.local` ファイルに Supabase の URL とキーを保存していました。しかし `.env.local` は Git に含まれていないため、Vercel にはその情報が届きません。

Vercel の「環境変数」機能を使って、本番サーバーにも同じ情報を安全に設定する必要があります。

> **環境変数って何？** アプリが動く「環境」ごとに変わる設定値のことです。「自分のパソコン」と「Vercel のサーバー」では環境が違うので、それぞれに別々に設定します。`.env.local` はメモ帳に書いた個人のメモ、Vercel の環境変数は会社の金庫に保管した公式な設定書類のイメージです。

### 2-1. 環境変数の値を確認する

ローカルの `.env.local` ファイルを確認して、設定する値を用意します。

```bash
cat .env.local
```

以下の 2 つの値が必要です。

```
NEXT_PUBLIC_SUPABASE_URL=https://xxxxxxxxxxxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciO...（長い文字列）
```

> **注意:** これらの値を第三者に教えないでください。特に `NEXT_PUBLIC_SUPABASE_ANON_KEY` は公開 API キーですが、Supabase の RLS（Module 4 で設定したセキュリティ機能）が有効であれば安全に使用できます。

### 2-2. Vercel に環境変数を設定する

Vercel のプロジェクト設定画面で環境変数を登録します。

**方法 A: プロジェクト作成時（推奨）**

1. Step 1 で開いたプロジェクト設定画面を使う
2. 「Environment Variables」セクションを展開する

[screenshot: Vercel のプロジェクト設定画面の「Environment Variables」セクション]

3. 「Name」と「Value」を入力する:
   - Name: `NEXT_PUBLIC_SUPABASE_URL`
   - Value: `.env.local` の `NEXT_PUBLIC_SUPABASE_URL` の値
4. 「Add」をクリックする
5. 同様に `NEXT_PUBLIC_SUPABASE_ANON_KEY` も追加する

[screenshot: Vercel に NEXT_PUBLIC_SUPABASE_URL と NEXT_PUBLIC_SUPABASE_ANON_KEY が追加された様子]

**方法 B: 既存プロジェクトの設定画面から**

1. Vercel ダッシュボードでプロジェクトを開く
2. 「Settings」タブをクリックする
3. 左メニューの「Environment Variables」を選択する
4. 同様に値を追加する

[screenshot: Vercel の Settings > Environment Variables 画面]

> **注意:** 環境変数を追加・変更した場合は、再デプロイが必要です。設定後に「Redeploy」ボタンを押すか、新たに `git push` を行ってください。

### 2-3. デプロイを実行する

環境変数の設定が完了したら、デプロイを実行します。

**方法 A: Vercel ダッシュボードから（初回推奨）**

プロジェクト設定画面の「Deploy」ボタンをクリックします。

[screenshot: Vercel のプロジェクト設定画面の「Deploy」ボタン]

**方法 B: Vercel CLI から**

```bash
vercel
```

初回実行時は対話形式で設定を聞かれます。

```
? Set up and deploy "~/workspace/its_my_turn"? [Y/n] y
? Which scope do you want to deploy to? → あなたのアカウント名を選択
? Link to existing project? [y/N] n
? What's your project's name? its-my-turn（または任意の名前）
? In which directory is your code located? ./
```

> **体験:** Claude Code に「Vercel にデプロイして」と依頼してみましょう。vercel コマンドの実行方法や、デプロイ前のチェックをサポートしてくれます。

> Vercel にデプロイして。デプロイ前に問題がないかビルドを確認して

Claude Code はまず `npm run build` でビルドが通るかを確認し、問題があれば修正してからデプロイを提案します。

> **ビルドとは？** プログラムのソースコードを、サーバーで動かせる形式に変換する処理です。料理でいえば「レシピ（コード）をもとに実際の料理（動くアプリ）を作る」工程です。

[screenshot: Claude Code がビルドチェックを行い、デプロイを提案している様子]

### 2-4. ビルドログを確認する

デプロイが始まると、Vercel ダッシュボードにビルドログが表示されます。

> **ビルドログとは？** デプロイ中に何が起きているかを記録したメッセージの一覧です。うまくいけば最後に成功メッセージが表示されます。エラーが起きれば、ここに原因が書かれています。

[screenshot: Vercel のビルドログ画面でデプロイが進行している様子]

ログの最後に以下のような表示が出れば成功です。

```
✓ Build completed
✓ Deployment completed
```

エラーが表示された場合は、「トラブルシューティング」を参照してください。

### Step 2 の確認ポイント

- [ ] `.env.local` に `NEXT_PUBLIC_SUPABASE_URL` と `NEXT_PUBLIC_SUPABASE_ANON_KEY` が存在する
- [ ] Vercel のプロジェクト設定に 2 つの環境変数が登録されている
- [ ] `vercel` コマンドを実行してエラーが出ない（CLI を使う場合）
- [ ] Vercel ダッシュボードでビルドが成功している（緑のチェックマーク）
- [ ] 公開 URL（`https://プロジェクト名.vercel.app` のような形式）が発行されている

---

## Step 3: 本番動作確認 & 振り返り（20分）

このステップでは、公開されたアプリの動作を確認し、Supabase の設定を本番用に更新します。

### 3-1. 公開 URL でアプリを確認する

Vercel ダッシュボードに表示された公開 URL（`https://プロジェクト名.vercel.app`）をブラウザで開きます。

[screenshot: 公開 URL でブラウザに TODO アプリが表示されている様子]

以下のチェックリストで動作を確認します。

- [ ] サインアップできる
- [ ] ログインできる
- [ ] TODO を追加できる
- [ ] TODO の一覧が表示される
- [ ] TODO を完了にできる
- [ ] TODO を削除できる
- [ ] ログアウトできる

> **注意:** サインアップ後にメール確認が必要な場合があります。登録したメールアドレスに確認メールが届いていないか確認してください。届いていない場合は Step 3-2 を先に実施してください。

### 3-2. Supabase の本番用 URL を設定する

Supabase の認証機能は、デフォルトで `localhost:3000`（自分のパソコン上のアドレス）からのアクセスのみ許可しています。本番の URL（`https://プロジェクト名.vercel.app`）を追加で登録する必要があります。

> **なぜこの設定が必要なの？** セキュリティのためです。「どこからでも認証できる」状態にするのは危険なため、Supabase はあらかじめ「許可するアドレスのリスト」を持っています。本番 URL をそのリストに追加することで、本番環境からもログインできるようになります。

1. Supabase ダッシュボード（`https://supabase.com/dashboard`）を開く
2. プロジェクトを選択する
3. 左メニューの「Authentication」をクリックする
4. 「URL Configuration」を選択する

[screenshot: Supabase ダッシュボードの Authentication > URL Configuration 画面]

5. 「Site URL」を本番 URL に更新する:
   ```
   https://プロジェクト名.vercel.app
   ```

6. 「Redirect URLs」に以下を追加する（「Add URL」をクリック）:
   ```
   https://プロジェクト名.vercel.app/**
   ```

[screenshot: Supabase の Redirect URLs に本番 URL が追加された様子]

7. 「Save」をクリックして保存する

> **注意:** Site URL を変更すると、`localhost:3000` でのローカル開発時に認証が動作しなくなることがあります。ローカル開発の URL も Redirect URLs に残しておくことを推奨します:
> ```
> http://localhost:3000/**
> https://プロジェクト名.vercel.app/**
> ```

### 3-3. CI/CD の体験（自動デプロイ）

GitHub への push で Vercel が自動デプロイされることを体験します。

> **CI/CD とは？** Continuous Integration / Continuous Delivery の略です。「コードを push すると自動でテスト・ビルド・デプロイが走る仕組み」のことです。注文（push）するだけで自動的に届けてくれるデリバリーサービスのイメージです。一度設定すれば、毎回手動でデプロイする必要がなくなります。

> **体験:** Claude Code に「TODO アプリに簡単な改善をして、GitHub に push して」と依頼してみましょう。Claude Code がコードを修正し、commit、push を行います。その後、Vercel が自動的に新バージョンをデプロイするまでの流れを体験します。

> TODO リストのスタイルを少し改善して、feature/style-tweak ブランチを作ってコミットして push して

[screenshot: GitHub への push 後、Vercel が自動デプロイしている様子]

---

### 振り返り: このカリキュラムで学んだ Claude Code 機能

| Module | 学んだ機能 |
|--------|-----------|
| 0 | CLI インストール、初期設定 |
| 1 | CLAUDE.md、Hooks、Agents、MCP サーバー |
| 2 | スキャフォールド、Git 操作 |
| 3 | Figma MCP サーバー、プロンプティング、反復修正 |
| 4 | DB 設計、SQL 生成 |
| 5 | 統合指示、エージェント活用、タスク分解 |
| 6 | コードレビュー、Git ブランチ運用 |
| 7 | CI/CD、本番設定 |

**このカリキュラムで体験したこと:**

- Claude Code に日本語で自然な指示を出すだけでコードが書かれる
- CLAUDE.md にルールを書いておけば、毎回同じことを説明しなくてよい
- エージェントを使うと専門的な役割を持った AI チームメンバーが動く
- Git のブランチ管理も Claude Code が自動でチェックしてくれる
- デプロイまでの一連の流れを Claude Code がサポートしてくれる

> **体験まとめ:** 最初は「ターミナルに何を打てばいいかわからない」状態から始まりました。今では Claude Code に日本語で依頼するだけで、コードの作成・修正・テスト・デプロイまでをサポートしてもらえます。これが Claude Code を使った開発の第一歩です。

### Step 3 の確認ポイント

- [ ] 公開 URL でサインアップ・ログインができる
- [ ] 公開 URL で TODO の追加・一覧・完了・削除ができる
- [ ] 公開 URL でログアウトができる
- [ ] Supabase の Site URL が本番 URL に更新されている
- [ ] Supabase の Redirect URLs に本番 URL が追加されている
- [ ] GitHub に push すると Vercel が自動デプロイすることを確認できた
- [ ] Slack にデプロイ完了の通知が届いた（任意）

---

## モジュール全体の確認ポイント

このモジュールを完了すると、以下の状態になっているはずです。

- [ ] **Vercel デプロイ済み**: 公開 URL でアプリが動いている
- [ ] **環境変数設定済み**: Vercel に Supabase の接続情報が登録されている
- [ ] **CI/CD 構築済み**: GitHub への push で自動デプロイが動く
- [ ] **Supabase 本番設定済み**: 本番 URL でサインアップ・ログインができる
- [ ] **全機能動作確認済み**: チェックリスト 7 項目がすべてクリア

---

## Module 0 への追記メモ

このモジュールで使ったツールを、Module 0（環境構築）のチェックリストに追加しておきましょう。

```markdown
## Module 7 で必要なもの（Module 0 に追記）

- [ ] Vercel アカウント（https://vercel.com で GitHub 連携して作成）
- [ ] Vercel CLI（`npm i -g vercel` でインストール）
- [ ] GitHub リポジトリ（プロジェクトのコードを管理する場所）
```

---

## トラブルシューティング

### ビルドエラーが出る

Vercel のビルドログにエラーが表示された場合、まずローカルでビルドを試みます。

```bash
npm run build
```

エラーが出た場合は Claude Code に依頼します。

> npm run build でエラーが出ています。ログを確認して修正して

ビルドエラーの原因として多いもの:

- TypeScript の型エラー（`any` を使っていないか確認）
- `process.env` の変数が undefined（環境変数名のスペルミス）
- Import パスのエラー（ファイルが存在しない、パスが間違っている）

> **TypeScript の型エラーとは？** TypeScript は「この変数には文字列しか入らないはず」という取り決めが厳しい言語です。取り決めに反したコードが含まれているとビルドが止まります。Claude Code に「型エラーを修正して」と伝えれば直してくれます。

---

### 環境変数が読み込まれない

Vercel にデプロイしてもアプリが Supabase に繋がらない場合:

1. Vercel ダッシュボード → プロジェクト → 「Settings」→「Environment Variables」で値が正しく入力されているか確認する
2. 環境変数の変数名に `NEXT_PUBLIC_` が付いているか確認する（ブラウザから読める変数には必須です）
3. 環境変数を変更したら「Redeploy」が必要

[screenshot: Vercel の Settings > Environment Variables で値を確認している様子]

```bash
# 環境変数の確認（ローカル）
cat .env.local
```

---

### Supabase の認証でリダイレクトエラーが出る

ログイン後に `Invalid redirect URL` のようなエラーが出る場合:

- Supabase ダッシュボード → 「Authentication」→「URL Configuration」を確認する
- 「Redirect URLs」に `https://プロジェクト名.vercel.app/**` が登録されているか確認する

> **「Invalid redirect URL」エラーとは？** 「このアドレスはリダイレクト先として許可されていません」というエラーです。Step 3-2 の設定を確認してください。

---

### vercel コマンドが認識されない

```bash
# npm のグローバルインストールパスを確認する
npm root -g

# Vercel CLI を再インストールする
npm uninstall -g vercel
npm install -g vercel

# インストール確認
vercel --version
```

---

### デプロイは成功したのにページが真っ白になる

Vercel のビルドログにエラーがなくても、ランタイムエラーが発生している可能性があります。

> **ランタイムエラーとは？** ビルド（準備）の段階では問題なかったのに、アプリが実際に動き始めると起きるエラーです。環境変数の設定ミスなどがこの原因になることがあります。

1. Vercel ダッシュボード → プロジェクト → 「Functions」タブでエラーログを確認する
2. または、ブラウザの開発者ツール（F12）→「Console」タブでエラーメッセージを確認する
3. エラーメッセージを Claude Code に貼り付けて原因を調べてもらう

> デプロイ後のページが真っ白になります。ブラウザのコンソールに以下のエラーがあります:（エラーメッセージを貼り付ける）

---

### GitHub への push が拒否される

```bash
# リモートリポジトリが登録されているか確認
git remote -v

# 登録されていない場合は追加する
git remote add origin https://github.com/あなたのユーザー名/リポジトリ名.git

# push する
git push -u origin main
```

認証エラーが出る場合は、GitHub の Personal Access Token（個人アクセストークン。GitHub を使うための鍵）が必要なことがあります。GitHub の設定画面（Settings → Developer settings → Personal access tokens）でトークンを生成してください。わからない場合はメンターに声をかけてください。

---

## このモジュールで学んだこと

| 機能 | 体験した内容 |
|------|-------------|
| **CI/CD 連携** | GitHub への push が Vercel の自動デプロイにつながる仕組みを構築し、「コードを保存するだけで公開される」体験をした |
| **本番設定** | ローカル用の `.env.local` の情報を Vercel の環境変数に移行し、本番サーバーでアプリが動く状態にした |
| **Supabase 本番設定** | 本番 URL を Supabase の許可リストに追加し、サインアップ・ログインが動作する状態にした |
| **デプロイ支援** | Claude Code に「デプロイして」と依頼するだけで、ビルドチェックからデプロイまでの手順をサポートしてもらえることを体験した |

---

## カリキュラム完了

全 8 モジュール（Module 0〜7）が完了しました。

公開 URL を友人や同僚に共有して、自分で作った TODO アプリを使ってもらいましょう。

**次のステップとして、こんなことを試してみてください:**

- 機能を追加してみる（カテゴリ分け、期限設定、優先度など）
- デザインを変更してみる（Figma MCP サーバーを使って）
- 別のプロジェクトで同じ手順を試してみる

Claude Code は今後も継続的に機能が追加されています。公式ドキュメント（`https://docs.anthropic.com/claude/docs/claude-code`）を確認して、新しい機能を取り入れてみてください。

---

前のモジュールへ: [Module 6: コードレビュー & Git 運用](./module-06-git-workflow.md)
