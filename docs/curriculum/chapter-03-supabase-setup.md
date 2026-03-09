# Chapter 3: Supabase の初期設定

**所要時間**: 約 45 分
**ゴール**: Supabase MCP サーバーが設定済み + クラウドデータベースに `todos` テーブルが作成された状態にする
**学ぶ Claude Code 機能**: MCP サーバー（外部サービス連携）

---

> [!WARNING]
> **このチャプターを始める前に:** Chapter 2 が終わった時点で、Claude Code は終了した状態になっています。ターミナルが開いていることを確認してから、このチャプターを進めてください。

---

## このチャプターで学ぶこと

- Supabase のアカウントを作成し、プロジェクトを立ち上げる
- MCP サーバーをインストールし、ブラウザ認証で Claude Code と Supabase を接続する
- Claude Code + MCP でクラウドの `todos` テーブルを直接作成する
- `.env.local` にクラウド接続情報を設定する
- このチャプターの作業が Git に記録されない理由を理解する

全部終わったら、クラウドの Supabase にテーブルが作成され、次のチャプターでアプリと接続できる準備が整います。

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

> [!NOTE]
> **Database Password について**: データベースに直接アクセスするための鍵です。今後使う場面があるため、パスワード管理ツールやメモ帳に必ず記録しておいてください。
>
> **Enable Data API とは？** アプリから Supabase のデータを読み書きするための入口（API）を有効にするスイッチです。これをオンにしないと、Next.js アプリから Supabase に接続できないため、必ずオンにしてください。

3. 「Create new project」ボタンをクリック

**確認ポイント**

- [ ] プロジェクトのダッシュボードが表示された（URL が `https://supabase.com/dashboard/project/xxxxxxxxxx` になっている）
- [ ] データベースパスワードを安全な場所に保存した

---

## Step 2: Supabase MCP サーバーの設定（5分）

### MCP サーバーって何？

> [!NOTE]
> **MCP サーバーとは？** Claude Code に外部サービスを操作する能力を追加する仕組みです。スマホにアプリを入れるとそのサービスが使えるようになるのと同じイメージです。Supabase の MCP サーバーを追加すると、Claude Code が直接データベースを操作できるようになります。

MCP サーバーがない場合、Claude Code が生成した SQL をコピーして、ブラウザのダッシュボードに貼り付けて実行する、という手順が必要でした。MCP サーバーを使うと、「テーブルを作って」と Claude Code に指示するだけで完了します。

---

### 2-1. MCP サーバーを追加する

ターミナルでプロジェクトフォルダにいることを確認し、以下のコマンドを実行します。

```bash
# bash
claude mcp add supabase --transport http https://mcp.supabase.com/mcp
```

> [!NOTE]
> **`--transport http` とは？** 「HTTP という通信方式で接続する」という指定です。インターネット上のサービスと話すときに使う一般的な方法で、「どのルートで情報を届けるか」を指定しているイメージです。

このコマンドを実行すると、ブラウザが自動的に開いて Supabase へのログイン画面が表示されます。これは Claude Code に「Supabase へのアクセス許可を与える」ための認証ステップです。画面に従ってログインすると、MCP サーバーの登録と認証がまとめて完了します。

---

### 2-2. Claude Code を起動して認証する

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

> [!NOTE]
> **なぜブラウザでログインするのか？** これは「Claude Code があなたの Supabase アカウントにアクセスする許可を与える」ための手順です。スマホのアプリで「Google でサインイン」ボタンを押すと Google のログイン画面が開いて許可を求めてくる、あの仕組みと同じです。パスワードを Claude Code に直接渡すのではなく、Supabase 側のログイン画面を経由することで安全に認証できます。

**確認ポイント**

- [ ] MCP サーバーが登録された（`claude mcp add` が完了した）
- [ ] `/mcp` コマンドで認証を実行した
- [ ] ブラウザでの認証が完了した

---

## Step 3: todos テーブルの作成（5分）

Claude Code は MCP サーバーを通じて、クラウドの Supabase に直接テーブルを作成できます。マイグレーションファイルの作成やローカル環境の起動は不要です。「テーブルを作って」と日本語で指示するだけで完了します。

> [!TIP]
> **体験:** SQL を自分で書く必要はありません。要件を日本語で伝えるだけで、Claude Code が適切なテーブル設計とセキュリティ設定を含んだテーブルをクラウドに直接作ってくれます。

Claude Code のプロンプトに以下を入力してください。

```plaintext
Supabase の todos プロジェクトに、todos テーブルを作って。
Row Level Security (RLS) を有効化して。ログインしたユーザーが自分の TODO だけを見れる・作れる・更新できる・削除できるようにして
```

> [!NOTE]
> **RLS（Row Level Security）とは？** 「行レベルのセキュリティ」という意味です。データベースの各行（各 TODO）に対して「誰が見られるか」を制御する仕組みです。これを有効にしておくと、ユーザー A のデータをユーザー B が覗けなくなります。

### テーブルを確認する

Supabase ダッシュボードを開き、左サイドバーの「Table Editor」をクリックします。`todos` テーブルが表示されていれば成功です。

**確認ポイント**

- [ ] Claude Code の指示でクラウドの Supabase に `todos` テーブルが作成された
- [ ] Supabase ダッシュボードの Table Editor に `todos` テーブルが表示されている
- [ ] RLS が有効になっている

---

> [!IMPORTANT]
> **ここで一度、立ち止まってください。Step 4 からは「全く違う種類の作業」に切り替わります。**

ここまでの Step 2〜3 では、**あなた（開発者）として** Supabase に接続していました。Claude Code が MCP サーバーを通じて Supabase にアクセスし、テーブルを作ったりプロジェクト情報を確認しました。

これから行う Step 4 は、**TODO アプリ（プログラム）が** Supabase に接続するための設定です。アプリが実際にデータを読み書きするために必要な接続情報を用意します。

この 2 つは全く別物です。下の表で整理しておきます。

| | 開発者としての接続（Step 2〜3） | アプリとしての接続（Step 4） |
|---|---|---|
| **誰が接続するか** | あなた（Claude Code 経由） | TODO アプリ |
| **何のために** | テーブル作成・DB 管理 | データの読み書き |
| **認証方法** | Authenticate（ブラウザでのログイン） | URL + Publishable Key |
| **いつ使うか** | 開発中のみ | アプリが動いている間ずっと |

---

## Step 4: 接続情報の設定（5分）

### 4-1. Publishable Key を確認する

1. ブラウザで Supabase ダッシュボードを開く
2. 左サイドバーの「Project Settings」→「API Keys」を開く
3. 「Publishable key」セクションから `sb_publishable_...` から始まるキーをコピーする

> [!NOTE]
> **Publishable Key とは？** 「公開しても安全」に設計された低権限のキーです。RLS（Row Level Security）を正しく機能させながら認証フローを動かします。もし仮に `sb_secret_` から始まるキー（service_role key）を使ってしまうと、管理者権限で RLS がバイパスされ「誰でも全ユーザーのデータを見られる」状態になってしまいます。

---

### 4-2. `.env.local` ファイルを作成する

> [!NOTE]
> **`.env.local` って何？** アプリの「秘密のメモ帳」のようなものです。パスワードや接続情報など、他の人に見せたくない設定値を保存するファイルです。このファイルは Git に含まれないため、インターネット上に公開される心配がありません。

Claude Code に以下を指示してください。

```plaintext
.env.local をクラウド接続用に設定して。NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY にはクラウドの Publishable Key を使って
```

Claude Code が作成する `.env.local` は以下のようになります。

```text
NEXT_PUBLIC_SUPABASE_URL=https://xxxxxxxxxx.supabase.co
NEXT_PUBLIC_SITE_URL=http://localhost:3000
NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY=sb_publishable_...（クラウドの Publishable Key）
```

> [!WARNING]
> **注意:** `NEXT_PUBLIC_SUPABASE_URL` が `https://xxxxxxxxxx.supabase.co`（クラウド）になっていることを確認してください。`http://127.0.0.1:54321` のようなローカルの URL ではありません。

---

### 4-3. `.gitignore` を確認する

`.env.local` には接続情報が含まれているため、Git に含めてはいけません。プロジェクトルートの `.gitignore`（Git が無視するファイルのリスト）に `.env.local` が含まれていることを確認します。

```bash
# bash
cat .gitignore | grep env
```

`.env.local` が出力に含まれていれば OK です。

> [!WARNING]
> **注意:** `.gitignore` に `.env.local` が含まれていない場合は、必ず追加してください。接続情報が GitHub などに公開されると、データが不正にアクセスされる危険があります。

**確認ポイント**

- [ ] `.env.local` ファイルがプロジェクトルートに作成された
- [ ] `NEXT_PUBLIC_SUPABASE_URL` が `https://xxxxxxxxxx.supabase.co`（クラウド）に設定されている
- [ ] `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` が設定されている（`sb_publishable_` から始まる文字列）
- [ ] `.gitignore` に `.env.local`（または `.env*.local`）が含まれている

---

## Step 5: このチャプターの作業は Git に記録されない

このチャプターでやった作業を振り返ってみましょう。

- `.env.local` ファイルの作成
- Supabase MCP サーバーの設定・認証

実は、この 2 つはどちらも Git に記録されません。これは設計上、正しい動作です。

**なぜ記録されないのか？**

`.env.local` は接続情報（URL・キー）を含むため、`.gitignore` によって最初から Git の管理対象外になっています。誤って GitHub に上げてしまうと、データが不正にアクセスされる危険があるため、このような設計になっています。

MCP サーバーの設定は、パソコン全体のユーザー設定として保存されます。特定のプロジェクトのファイルではないため、こちらも Git の対象外です。

**「コミットするものがない」が正解**

試しに Claude Code に指示してみましょう。

```plaintext
今回の作業をコミットして
```

Claude Code は「コミットするものがない（nothing to commit）」と返答します。これはエラーではなく、正しい結果です。大事な情報が Git に記録されない設計になっている、という確認ができました。

**確認ポイント**

- [ ] `.env.local` が `.gitignore` で除外されている設計を理解した
- [ ] 「コミットするものがない」と Claude Code が返答した（正しい結果）

---

## チャプター全体の確認ポイント

Claude Code を終了します。

```plaintext
/exit
```

このチャプターの全作業が終わったら、以下をまとめて確認してください。

- [ ] Supabase プロジェクトが作成されている
- [ ] Supabase MCP サーバーが設定・認証されている
- [ ] クラウドの Table Editor に `todos` テーブルが存在する
- [ ] `.env.local` の `NEXT_PUBLIC_SUPABASE_URL` が `https://xxxxxxxxxx.supabase.co`（クラウド）に設定されている
- [ ] `.env.local` に `NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY` が設定されている

---

## このチャプターで学んだこと

| 機能 | 体験した内容 |
|------|-------------|
| **MCP サーバー（外部サービス連携）** | `claude mcp add` で Supabase の MCP サーバーを追加し、ブラウザ認証して Claude Code からクラウドデータベースを直接操作できる状態を作った |
| **DB 設計指示** | 日本語でテーブル要件を伝えるだけで、適切な SQL（RLS ポリシー含む）を含んだテーブルをクラウドに直接作成してもらえることを体験した |

---

[← Chapter 2: Claude Code を整える](chapter-02-claude-code.md) | [Chapter 4: Vibe Coding で TODO アプリを作る →](chapter-04-development.md)
