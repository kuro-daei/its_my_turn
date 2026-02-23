# Chapter 3: Supabase 初期設定

**所要時間**: 約 40 分
**ゴール**: Supabase MCP サーバーが設定済み + ローカル Supabase が起動 + データベースのテーブルが作成された状態にする
**学ぶ Claude Code 機能**: MCP サーバー（外部サービス連携）、マイグレーション（データベース変更管理）

---

> **このチャプターを始める前に:** Chapter 2 が終わった時点で、Claude Code は終了した状態になっています。ターミナルが開いていることを確認してから、このチャプターを進めてください。

---

## このチャプターで学ぶこと

- Supabase のアカウントを作成し、プロジェクトを立ち上げる
- MCP サーバーをインストールし、ブラウザ認証で Claude Code と Supabase を接続する
- ローカル（自分のパソコン上）に Supabase を起動する
- マイグレーションファイルを使って `todos` テーブルを作成し、クラウドに同期する
- `.env.local` にローカル接続情報を設定する
- コミットする

全部終わったら、ローカル Supabase が動いてテーブルが作成され、次のチャプターでアプリと接続できる準備が整います。

---

**「Supabase って何？」という疑問に先に答えます**

Supabase（スーパーベース）は、データを安全に保管してくれるレンタル倉庫のようなものです。TODO アプリで作ったデータ（「買い物に行く」「メールを返す」など）をインターネット上に保存・管理してくれるサービスです。

通常、こういったサービスを用意するには専門的な知識が必要ですが、Supabase を使えば数分でデータベース（DB。大量のデータを整理して保管する仕組み）が使えるようになります。

間違えても大丈夫です。途中でわからなくなったら、すぐメンターに声をかけてください。

---

## Step 1: Supabase プロジェクトの作成（5分）

### 1-1. アカウント作成

1. ブラウザで `https://supabase.com` を開く
2. 右上の「Start your project」または「Sign Up」ボタンをクリック
3. 登録方法を選んでクリックする。GitHub・Google アカウントでの連携、またはメールアドレスとパスワードでの登録が利用できます。いずれかお好みの方法で登録してください
4. 画面の指示に従って認証を完了させる

**確認ポイント**

- [ ] Supabase のダッシュボード（`https://supabase.com/dashboard`）にログインできた

---

### 1-2. 新規プロジェクトの作成

ダッシュボードが表示されたら、新しいプロジェクトを作成します。

1. ダッシュボード左上の「New project」ボタンをクリック
2. プロジェクトの設定を入力する

| 項目 | 入力内容 |
|------|---------|
| **Organization** | 自動で作成された組織名のまま（変更不要） |
| **Name** | `todos`（または任意のプロジェクト名） |
| **Database Password** | 強力なパスワードを入力する（後で必要になるので必ず保存） |
| **Region** | `Northeast Asia (Tokyo)` を選択（日本に近いため表示速度が速い） |
| **Security / Enable Data API** | トグルスイッチをオンにする |

> **Database Password について**: データベースに直接アクセスするための鍵です。今後使う場面があるため、パスワード管理ツールやメモ帳に必ず記録しておいてください。

> **Enable Data API とは？** アプリから Supabase のデータを読み書きするための入口（API）を有効にするスイッチです。これをオンにしないと、Next.js アプリから Supabase に接続できないため、必ずオンにしてください。

3. 「Create new project」ボタンをクリック

**確認ポイント**

- [ ] プロジェクトのダッシュボードが表示された（URL が `https://supabase.com/dashboard/project/xxxxxxxxxx` になっている）
- [ ] データベースパスワードを安全な場所に保存した

---

## Step 2: Supabase MCP サーバーの設定（5分）

### MCP サーバーって何？

> **MCP サーバーとは？** Claude Code に外部サービスを操作する能力を追加する仕組みです。スマホにアプリを入れるとそのサービスが使えるようになるのと同じイメージです。Supabase の MCP サーバーを追加すると、Claude Code が直接データベースを操作できるようになります。

MCP サーバーがない場合、Claude Code が生成した SQL をコピーして、ブラウザのダッシュボードに貼り付けて実行する、という手順が必要でした。MCP サーバーを使うと、「テーブルを作って」と Claude Code に指示するだけで完了します。

---

### 2-1. npm パッケージをインストールする

ターミナルでプロジェクトフォルダにいることを確認し、以下を実行してください。

```bash
npm install --save-dev supabase
```

> **`--save-dev` とは？** このプロジェクトの開発用ツールとして追加する、という意味です。アプリ本体には含まれず、開発中にだけ使う道具として管理されます。

---

### 2-2. MCP サーバーを追加する

続けて以下のコマンドを実行します。

```bash
claude mcp add supabase --transport http https://mcp.supabase.com/mcp
```

これで Supabase の MCP サーバーが Claude Code に登録されます。この時点ではまだ認証は行われていません。

---

### 2-3. Claude Code を起動して認証する

ターミナルで Claude Code を起動します。

```bash
claude
```

起動したら、プロンプトで以下を入力します。

```plaintext
/mcp
```

MCP サーバーの一覧が表示されるので、Supabase を選んで認証を実行してください。認証用の URL が発行されます。

その URL をコピーして、ブラウザのアドレスバーに貼り付けてください。Supabase のログイン画面が表示されるのでログインすると認証完了です。

> **なぜブラウザでログインするのか？** これは「Claude Code があなたの Supabase アカウントにアクセスする許可を与える」ための手順です。スマホのアプリで「Google でサインイン」ボタンを押すと Google のログイン画面が開いて許可を求めてくる、あの仕組みと同じです。パスワードを Claude Code に直接渡すのではなく、Supabase 側のログイン画面を経由することで安全に認証できます。

**確認ポイント**

- [ ] Supabase の npm パッケージがインストールされた（`npm install` が完了した）
- [ ] MCP サーバーが登録された（`claude mcp add` が完了した）
- [ ] `/mcp` コマンドで認証を実行した
- [ ] ブラウザでの認証が完了した

---

## Step 3: ローカル Supabase の起動（10分）

### なぜローカルで開発するの？

> クラウドの管理画面（`https://supabase.com/dashboard`）でも確認できますが、ローカルで Supabase を動かすと**ページを切り替えることなくすぐ確認でき**、開発のリズムが崩れません。また、接続が速く、本番データを誤って変更するリスクもありません。

Step 2 で `npm install --save-dev supabase` は完了しているので、追加のインストールは不要です。

### 3-1. Claude Code に supabase を初期化させる

**ターミナルでコマンドを打つのではなく、Claude Code（Step 2-3 で起動済み）に指示します。**

Claude Code のプロンプトに以下を入力してください。

```plaintext
supabase を初期化して
```

Claude Code が `npx supabase init` を実行し、`supabase/` フォルダを作成します。

> **何が起きる？** `supabase/` というフォルダが作成されます。これがローカル開発の設定フォルダです。

### 3-2. クラウドプロジェクトとリンクさせる

引き続き Claude Code に指示します。

```plaintext
Supabase のプロジェクト「todos」とローカルをリンクして
```

> **たとえ:** クラウドの倉庫（Supabase プロジェクト）と手元の作業場（ローカル環境）を「同じプロジェクトのもの」として結びつける操作です。

Supabase MCP がすでに認証済みなので、Claude Code がプロジェクト名からプロジェクト ID を自動で調べて `npx supabase link` を実行してくれます。URL から文字列を探す必要はありません。

### 3-3. ローカル Supabase を起動する

> **事前確認:** Docker Desktop が起動していることを確認してください。タスクバーまたは画面上部のメニューバーに Docker のアイコンが表示されていれば OK です。起動していない場合は Docker Desktop アプリを先に開いてください。

**新しいターミナルを開いて**（Claude Code を使っているターミナルとは別に）、以下を実行してください。

```bash
npx supabase start
```

しばらくすると、以下のような出力が表示されます。

```text
Started supabase local development setup.

         API URL: http://127.0.0.1:54321
     GraphQL URL: http://127.0.0.1:54321/graphql/v1
  S3 Storage URL: http://127.0.0.1:54321/storage/v1/s3
          DB URL: postgresql://postgres:postgres@127.0.0.1:54322/postgres
      Studio URL: http://127.0.0.1:54323
    Inbucket URL: http://127.0.0.1:54324
      anon key: eyJ...
service_role key: eyJ...
```

`Studio URL` と ローカルの Publishable Key（出力の `anon key`）の値をメモしておいてください（Step 5 で使います）。

> **このターミナルは閉じないでください。** `npx supabase start` はデータベースを動かし続けるプロセスです。開発中はこのターミナルを開いたままにしておいてください。

### 3-4. ローカル Studio で確認する

`http://127.0.0.1:54323` をブラウザで開いてください。ローカルの Supabase Studio が表示されれば成功です。

**確認ポイント**

- [ ] Claude Code の指示で `supabase/` フォルダが作成された
- [ ] Claude Code の指示でクラウドプロジェクトとのリンクが完了した
- [ ] 別のターミナルで `npx supabase start` を実行し、Studio URL とローカルの Publishable Key が表示された
- [ ] `http://127.0.0.1:54323` をブラウザで開くと Supabase Studio が表示された

---

## Step 4: todos テーブルの作成（10分）

### マイグレーションって何？

> データベースへの変更内容を「変更手順書」としてファイルに記録しておく仕組みです。「いつ・どんな変更をしたか」が履歴として残るため、ローカルで作った手順書をクラウドに送るだけで同じ状態を再現できます。

### 4-1. マイグレーションファイルを Claude Code に作らせる

Claude Code を起動します。

```bash
claude
```

以下を入力してください。

```plaintext
Supabase の todos プロジェクト向けに、todos テーブルを作るマイグレーションファイルを supabase/migrations/ に作って。
Row Level Security (RLS) を有効化して。ログインしたユーザーが自分の TODO だけを見れる・作れる・更新できる・削除できるようにして
```

Claude Code が `supabase/migrations/YYYYMMDDHHMMSS_create_todos.sql` というファイルを作成します。

> **体験:** SQL を自分で書く必要はありません。要件を日本語で伝えるだけで、Claude Code が正しい SQL とセキュリティ設定を含んだマイグレーションファイルを作ってくれます。

### 4-2. ローカルに反映する

Claude Code に指示します。

```plaintext
マイグレーションをローカルの Supabase に反映して
```

> **何が起きる？** 作成されたマイグレーションファイルがローカルのデータベースに適用され、`todos` テーブルが作成されます。

### 4-3. ローカル Studio でテーブルを確認する

`http://127.0.0.1:54323` をブラウザで開き、左サイドバーの「Table Editor」をクリックします。`todos` テーブルが表示されていれば成功です。

### 4-4. クラウドに同期する

Claude Code に指示します。

```plaintext
マイグレーションをクラウドの Supabase に同期して
```

> **体験:** ローカルで作ったデータベースの設計を、一言指示するだけでクラウドに反映できました。これがマイグレーションを使った開発の強みです。

**確認ポイント**

- [ ] `supabase/migrations/` にファイルが作成されている
- [ ] ローカル Studio の Table Editor に `todos` テーブルが表示されている
- [ ] Claude Code の指示でクラウドへの同期が完了した
- [ ] クラウドのダッシュボードの Table Editor にも `todos` テーブルが表示されている

---

> **ここで一度、立ち止まってください。Step 5 からは「全く違う種類の作業」に切り替わります。**

ここまでの Step 2〜4 では、**あなた（開発者）として** Supabase に接続していました。Claude Code が MCP サーバーを通じて Supabase にアクセスし、テーブルを作ったりプロジェクト情報を確認しました。

これから行う Step 5 は、**TODO アプリ（プログラム）が** Supabase に接続するための設定です。アプリが実際にデータを読み書きするために必要な接続情報を用意します。

この 2 つは全く別物です。下の表で整理しておきます。

| | 開発者としての接続（Step 2〜4） | アプリとしての接続（Step 5） |
|---|---|---|
| **誰が接続するか** | あなた（Claude Code 経由） | TODO アプリ |
| **何のために** | テーブル作成・DB 管理 | データの読み書き |
| **認証方法** | Authenticate（ブラウザでのログイン） | URL + Publishable Key |
| **いつ使うか** | 開発中のみ | アプリが動いている間ずっと |

---

## Step 5: 接続情報の設定（5分）

### 5-1. Publishable Key をメモしておく（Chapter 6 で使います）

本番デプロイ（Chapter 6）では、クラウドの Supabase に接続します。そのときに `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` の値をクラウドのキーに差し替えます。今のうちにメモしておきましょう。

1. ブラウザで Step 1 で作成したプロジェクトのダッシュボードを開く
2. 左サイドバーの「Project Settings」→「API Keys」を開く
3. 「Publishable key」セクションから `sb_publishable_...` から始まるキーをコピーする
4. コピーしたキーをメモしておく（Chapter 6 で使います）

> **Publishable Key とは？** 「公開しても安全」に設計された低権限のキーです。RLS（Row Level Security）を正しく機能させながら認証フローを動かします。もし仮に `sb_secret_` から始まるキー（service_role key）を使ってしまうと、管理者権限で RLS がバイパスされ「誰でも全ユーザーのデータを見られる」状態になってしまいます。

### 5-2. `.env.local` ファイルを作成する

> **`.env.local` って何？** アプリの「秘密のメモ帳」のようなものです。パスワードや接続情報など、他の人に見せたくない設定値を保存するファイルです。このファイルは Git に含まれないため、インターネット上に公開される心配がありません。

今は**ローカル開発用**の接続情報を設定します。Claude Code に以下を指示してください。

```plaintext
.env.local をローカル接続用に設定して。NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY にはローカルの Publishable Key を使って
```

Claude Code が作成する `.env.local` は以下のようになります。

```dotenv
# .env.local
NEXT_PUBLIC_SUPABASE_URL=http://127.0.0.1:54321
NEXT_PUBLIC_SITE_URL=http://localhost:3000
NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY=eyJ...（ローカルの Publishable Key）
```

> **ローカルとクラウドで変数名を統一する理由:** ローカルの Supabase が発行するキー（`supabase start` 出力の `anon key`）が、ローカル版の Publishable Key です。Chapter 6 でクラウドに切り替えるときは、同じ変数 `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` の値を `sb_publishable_...` に差し替えるだけです。アプリのコードを変える必要はありません。

> **注意:** `NEXT_PUBLIC_SUPABASE_URL` が `http://127.0.0.1:54321`（ローカル）になっていることを確認してください。クラウドの URL（`https://xxxxxxxxxx.supabase.co`）ではありません。

### 5-3. `.gitignore` を確認する

`.env.local` には接続情報が含まれているため、Git に含めてはいけません。プロジェクトルートの `.gitignore`（Git が無視するファイルのリスト）に `.env.local` が含まれていることを確認します。

```bash
cat .gitignore | grep env
```

`.env.local` が出力に含まれていれば OK です。

> **注意:** `.gitignore` に `.env.local` が含まれていない場合は、必ず追加してください。接続情報が GitHub などに公開されると、データが不正にアクセスされる危険があります。

**確認ポイント**

- [ ] `.env.local` ファイルがプロジェクトルートに作成された
- [ ] `NEXT_PUBLIC_SUPABASE_URL` が `http://127.0.0.1:54321`（ローカル）に設定されている
- [ ] `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` が設定されている（`eyJ` から始まる長い文字列）
- [ ] `.gitignore` に `.env.local`（または `.env*.local`）が含まれている

---

## Step 6: コミット（5分）

確認が取れたら、作業内容をコミットします。

> **コミットとは？** その時点のファイルの状態を「セーブポイント」として記録することです。ゲームのセーブのように「この状態に戻れる」記録を残せます。

Claude Code に日本語で指示するだけでコミットが完了します（Chapter 2 の Step 5 と同じ体験です）。

```plaintext
今回の作業をコミットして
```

Claude Code がファイルの確認、コミットメッセージの作成、コミットまで行ってくれます。

コミットが完了したら、GitHub に push します。

```plaintext
push して
```

**確認ポイント**

- [ ] `.env.local` がコミットに含まれていないことを確認した
- [ ] コミットが完了した
- [ ] GitHub に push できた

---

## チャプター全体の確認ポイント

Claude Code を終了します。

```plaintext
/exit
```

このチャプターの全作業が終わったら、以下をまとめて確認してください。

- [ ] Supabase プロジェクトが作成されている
- [ ] Supabase MCP サーバーが設定・認証されている
- [ ] ローカル Supabase が起動している（`http://127.0.0.1:54323` でアクセスできる）
- [ ] `supabase/migrations/` に todos テーブルのマイグレーションファイルがある
- [ ] ローカルとクラウドの Table Editor に `todos` テーブルが存在する
- [ ] `.env.local` に `NEXT_PUBLIC_SUPABASE_URL`（ローカル）と `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` が設定されている

---

## トラブルシューティング

### Supabase プロジェクト作成時のエラー

**「Database password is too weak」と表示される場合:**

大文字・小文字・数字・記号を組み合わせた 8 文字以上のパスワードを設定してください（例: `MyPass123!`）。

**プロジェクト作成が何分経っても完了しない場合:**

ブラウザをリロードして確認してください。バックグラウンドで完了している場合があります。

---

### MCP サーバー関連のトラブル

**「接続エラーが出る」または「Supabase の情報が取得できない」場合:**

Claude Code を再起動して `claude mcp add` からやり直してください。

---

### ローカル Supabase 関連のトラブル

**「Docker is not running」と表示される場合:**

Docker Desktop が起動していないため、Docker Desktop アプリを起動してから再度 `npx supabase start` を実行してください。

**`npx supabase link` でエラーになる場合:**

`<PROJECT_REF>` が正しいか確認してください。Supabase ダッシュボードの URL（`https://supabase.com/dashboard/project/xxxxxxxxxx`）の `xxxxxxxxxx` の部分です。

**`npx supabase db push` でエラーになる場合:**

Supabase にログインしていない可能性があります。以下を実行してログインしてください。

```bash
npx supabase login
```

---

## このチャプターで学んだこと

| 機能 | 体験した内容 |
|------|-------------|
| **MCP サーバー（外部サービス連携）** | `claude mcp add` で Supabase の MCP サーバーを追加し、ブラウザ認証して Claude Code から直接データベースを操作できる状態を作った |
| **ローカル Supabase** | `npx supabase start` でパソコン上に Supabase を起動し、ブラウザでデータを直接確認できる環境を作った |
| **マイグレーション** | データベースの変更内容をファイルに記録し、ローカルで確認してからクラウドに同期するフローを体験した |
| **DB 設計指示** | 日本語でテーブル要件を伝えるだけで、適切な SQL（RLS ポリシー含む）を含んだマイグレーションファイルを作成してもらえることを体験した |

---

## 次のチャプターへ

Supabase のセットアップが完了しました。ローカル Supabase が動いている状態のまま、次のチャプターに進みます。

次の **Chapter 4: Vibe Coding で TODO アプリを作る** では、このデータベースと画面を実際につなぎ、TODO の追加・一覧表示・完了切り替え・削除が動く状態にします。さらにログイン機能も組み込み、自分専用のアプリが完成します。
