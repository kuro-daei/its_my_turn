# Chapter 3: Supabase 初期設定

**所要時間**: 約 30 分
**ゴール**: Supabase プラグインがインストール済み + Supabase のデータベースが立ち上がった状態にする
**学ぶ Claude Code 機能**: プラグイン（外部サービス連携）、データベース設計の指示、SQL 生成

---

> **このチャプターを始める前に:** Chapter 2 が終わった時点で、Claude Code は終了した状態になっています。ターミナルが開いていることを確認してから、このチャプターを進めてください。

---

## このチャプターで学ぶこと

- Supabase のアカウントを作成し、プロジェクトを立ち上げる
- プラグイン（外部サービス連携の仕組み）をインストールし、Claude Code と Supabase を接続する
- プラグインの認証を完了させ、Claude Code から Supabase を直接操作できる状態にする
- `todos` テーブルを Claude Code に直接作成させる（SQL のコピー&ペーストは不要）
- `.env.local` に接続情報を設定する
- コミットする

全部終わったら、Supabase のデータベースが立ち上がり、次のチャプターでアプリと接続できる準備が整います。

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
3. 「Continue with GitHub」を選択（GitHub アカウントがある場合は推奨）。
   または、メールアドレスとパスワードで登録する
4. GitHub 連携の場合は「Authorize supabase」をクリックして認証を完了させる

> **なぜ GitHub 連携が便利なの？** 別のパスワードを覚える必要がなく、すでに使っている GitHub アカウントでログインできます。サービス間の連携がスムーズになるため推奨です。

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
| **Plan** | `Free` のまま |

> **Database Password について**: データベースに直接アクセスするための鍵です。今後使う場面があるため、パスワード管理ツールやメモ帳に必ず記録しておいてください。

3. 「Create new project」ボタンをクリック

> **注意:** データベースのセットアップには 1〜2 分かかります。「Setting up your project...」という表示が消えるまで待ってください。

**確認ポイント**

- [ ] プロジェクトのダッシュボードが表示された（URL が `https://supabase.com/dashboard/project/xxxxxxxxxx` になっている）
- [ ] データベースパスワードを安全な場所に保存した

---

## Step 2: Supabase プラグインのインストール（5分）

### プラグインって何？

> **プラグインとは？** Claude Code に追加機能をインストールする仕組みです。スマホにアプリを入れるとそのサービスが使えるようになるのと同じイメージです。Supabase プラグインを入れると、Claude Code が直接データベースを操作できるようになります。

プラグインを使わない場合、Claude Code が生成した SQL をコピーして、ブラウザのダッシュボードに貼り付けて実行する、という手順が必要でした。プラグインを使うと、「テーブルを作って」と Claude Code に指示するだけで完了します。

---

### 2-1. アクセストークンを取得する

Supabase プラグインを使うには、まず Supabase の「Personal Access Token（パーソナルアクセストークン）」を取得する必要があります。

1. ブラウザで Supabase ダッシュボードを開く
2. 左下のアカウントアイコン → 「Access tokens」をクリック（または直接 `https://supabase.com/dashboard/account/tokens` にアクセス）
3. 「Generate new token」をクリック
4. トークン名を入力（例: `claude-code`）
5. 「Generate token」をクリック
6. 表示されたトークン（`sbp_` で始まる文字列）を**必ずコピーして安全な場所に保存する**

> **注意:** トークンは一度しか表示されません。ページを閉じると二度と確認できないため、必ずこの時点でコピーしてメモ帳やパスワード管理ツールに保存してください。
>
> **Personal Access Token とは？** Supabase が「このアクセスは本人からのものです」と確認するための鍵です。この鍵を使って Claude Code が Supabase にアクセスできるようになります。

---

### 2-2. プラグインをインストールする

Claude Code を起動します。

```bash
cd ~/workspace/todos
claude
```

Claude Code が起動したら、以下を入力してプラグインをインストールします。

```plaintext
/install-plugin supabase @ claude-plugins-official
```

インストール中に Supabase のアクセストークンを入力する画面が表示されます。先ほどコピーした `sbp_` で始まるトークンを貼り付けてください。

---

### 2-3. 接続を確認する

プラグインのインストールが完了したら、続けて以下を入力して接続を確認します。

```plaintext
Supabase のプロジェクト一覧を表示して
```

Step 1 で作成した `todos` プロジェクトが表示されれば成功です。

> **体験:** ブラウザを開かなくても、Claude Code から Supabase のプロジェクト情報を確認できるようになりました。これがプラグインの力です。

**確認ポイント**

- [ ] Supabase の Personal Access Token を取得して保存した
- [ ] `/install-plugin supabase @ claude-plugins-official` が正常に完了した
- [ ] Claude Code のプロンプトで `todos` プロジェクトの情報が表示された

---

## Step 3: todos テーブルの作成（10分）

プラグインが使えるようになったので、SQL を手動でコピー&ペーストする必要はありません。Claude Code に直接指示するだけでテーブルが作れます。

> **SQL（エスキューエル）とは？** データベースを操作するための「命令言語」です。以前は Claude Code が SQL を生成して、それをダッシュボードに貼り付けて実行する必要がありました。今は Claude Code がプラグインを通じて直接実行してくれます。

### 3-1. Claude Code にテーブルを作らせる

引き続き Claude Code のプロンプトで、以下を入力してください。

```plaintext
Supabase の todos プロジェクトに TODO管理用の `todos` テーブルを作って。
Row Level Security (RLS) を有効化して。ログインしたユーザーが自分の TODO だけを見れる・作れる・更新できる・削除できるようにして
```

Claude Code が Supabase プラグインを通じて、テーブルの作成と RLS の設定を直接実行してくれます。

> **体験:** ダッシュボードを開いて SQL をコピペする必要がなくなりました。Claude Code に日本語で指示するだけでデータベースが作れます。

---

### 3-2. Claude Code が実行する SQL（参考）

Claude Code が内部で生成・実行する SQL は以下のようなものです（参考として掲載しています。コピーする必要はありません）。

```sql
-- todos テーブルの作成
CREATE TABLE todos (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  completed BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now(),
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE
);

-- Row Level Security を有効化
ALTER TABLE todos ENABLE ROW LEVEL SECURITY;

-- ポリシー: 自分の TODO だけ閲覧できる
CREATE POLICY "Users can view their own todos"
  ON todos FOR SELECT
  USING (auth.uid() = user_id);

-- ポリシー: 自分の TODO だけ作成できる
CREATE POLICY "Users can create their own todos"
  ON todos FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- ポリシー: 自分の TODO だけ更新できる
CREATE POLICY "Users can update their own todos"
  ON todos FOR UPDATE
  USING (auth.uid() = user_id);

-- ポリシー: 自分の TODO だけ削除できる
CREATE POLICY "Users can delete their own todos"
  ON todos FOR DELETE
  USING (auth.uid() = user_id);
```

> **RLS（Row Level Security）って何？** 「行レベルのセキュリティ」という意味で、マンションの各部屋のようなイメージです。自分の部屋（データ）は自分だけが入れる、他の人の部屋には入れない、という仕組みです。「Aさんの TODO を Bさんが見たり削除したりする」ことを防げます。

---

### 3-3. テーブルが作成されたことを確認する

ブラウザで Supabase ダッシュボードを開き、テーブルが作成されていることを確認します。

1. Supabase ダッシュボードの左サイドバーの「Table Editor」をクリック
2. `todos` テーブルが一覧に表示されていることを確認する
3. `todos` テーブルをクリックして、カラムの構成を確認する

> **カラム（列）とは？** 表でいう「列」にあたるものです。Excel でいえば「氏名」「年齢」「住所」といった列の見出しのような概念です。

**確認ポイント**

- [ ] Table Editor に `todos` テーブルが表示されている
- [ ] `todos` テーブルに 必要なカラムがある

---

> **ここで一度、立ち止まってください。Step 4 からは「全く違う種類の作業」に切り替わります。**

ここまでの Step 2〜3 では、**あなた（開発者）として** Supabase に接続していました。Claude Code がプラグインを通じて Supabase にアクセスし、テーブルを作ったりプロジェクト情報を確認しました。

これから行う Step 4 は、**TODO アプリ（プログラム）が** Supabase に接続するための設定です。アプリが実際にデータを読み書きするために必要な接続情報を用意します。

この 2 つは全く別物です。下の表で整理しておきます。

| | 開発者としての接続（Step 2〜3） | アプリとしての接続（Step 4） |
|---|---|---|
| **誰が接続するか** | あなた（Claude Code 経由） | TODO アプリ |
| **何のために** | テーブル作成・DB 管理 | データの読み書き |
| **認証方法** | Personal Access Token | URL + anon key |
| **いつ使うか** | 開発中のみ | アプリが動いている間ずっと |

---

## Step 4: 接続情報の設定（5分）

### 4-1. 接続情報を Claude Code に取得させる

> **接続情報とは？** アプリが「どの Supabase プロジェクトに接続するか」を識別するための情報です。家の住所と玄関の鍵のセットのようなもので、URL が住所、anon key が鍵に相当します。

プラグインがインストールされているので、Claude Code に接続情報の取得を依頼できます。Claude Code のプロンプトで以下を入力してください。

```plaintext
Supabase の todos プロジェクトの URL と anon key を教えて
```

Claude Code が値を表示してくれるので、表示された値をメモしておいてください。

Claude Code を一度終了します。

```plaintext
/exit
```

> **`/exit` とは？** Claude Code を終了してターミナルに戻るコマンドです。

---

### 4-2. `.env.local` ファイルを作成する

> **`.env.local` って何？** アプリの「秘密のメモ帳」のようなものです。パスワードや接続情報など、他の人に見せたくない設定値を保存するファイルです。このファイルは Git に含まれないため、インターネット上に公開される心配がありません。

ターミナルでプロジェクトルートに移動します（Claude Code を終了した後のターミナルで作業します）。

```bash
cd ~/workspace/todos
```

テキストエディタで `.env.local` ファイルを新規作成して、以下の内容を記述します。`your-url` と `your-anon-key` の部分を先ほど Claude Code が表示した実際の値に置き換えてください。

```dotenv
# .env.local
NEXT_PUBLIC_SUPABASE_URL=https://xxxxxxxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

> **`NEXT_PUBLIC_` って何？** Next.js のルールで、この文字列で始まる変数名は「ブラウザ側のコードからも読み取れる」という意味になります。Supabase の URL と anon key は、ブラウザから直接やりとりするために必要なため、このプレフィックス（接頭語）が付いています。

---

### 4-3. `.gitignore` を確認する

`.env.local` には接続情報が含まれているため、Git に含めてはいけません。プロジェクトルートの `.gitignore`（Git が無視するファイルのリスト）に `.env.local` が含まれていることを確認します。

```bash
cat .gitignore | grep env
```

`.env.local` が出力に含まれていれば OK です。Next.js のデフォルト設定では以下のように記載されているはずです。

```gitignore
# local env files
.env*.local
```

> **注意:** `.gitignore` に `.env.local` が含まれていない場合は、必ず追加してください。接続情報が GitHub などに公開されると、データが不正にアクセスされる危険があります。わからない場合はメンターに確認してください。

**確認ポイント**

- [ ] `.env.local` ファイルがプロジェクトルートに作成された
- [ ] `NEXT_PUBLIC_SUPABASE_URL` と `NEXT_PUBLIC_SUPABASE_ANON_KEY` が正しく設定されている
- [ ] `.gitignore` に `.env.local`（または `.env*.local`）が含まれている

---

## Step 5: コミット（5分）

確認が取れたら、作業内容をコミットします。

> **コミットとは？** その時点のファイルの状態を「セーブポイント」として記録することです。ゲームのセーブのように「この状態に戻れる」記録を残せます。

Claude Code に日本語で指示するだけでコミットが完了します（Chapter 2 の Step 5 と同じ体験です）。

```plaintext
今回の作業をコミットして。`.env.local` は絶対に含めないで
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
- [ ] Supabase プラグインがインストールされている
- [ ] Supabase の Table Editor に `todos` テーブルが存在する
- [ ] `.env.local` に `NEXT_PUBLIC_SUPABASE_URL` と `NEXT_PUBLIC_SUPABASE_ANON_KEY` が設定されている

---

## トラブルシューティング

### Supabase プロジェクト作成時のエラー

**「Database password is too weak」と表示される場合:**

パスワードに大文字・小文字・数字・記号を組み合わせた 8 文字以上のものを設定してください。例: `MyPass123!`

**プロジェクト作成が何分経っても完了しない場合:**

ブラウザをリロードしてダッシュボードを確認してください。バックグラウンドでセットアップが完了している場合があります。

---

### プラグイン関連のトラブル

**「プラグインがインストールできない」または「接続エラーが出る」場合:**

まず Claude Code を再起動して、もう一度インストールを試みてください。

```bash
cd ~/workspace/todos
claude
```

```plaintext
/install-plugin supabase @ claude-plugins-official
```

**「Supabase のプロジェクト一覧を表示して」と言っても何も表示されない場合:**

トークンが正しく設定されていない可能性があります。Supabase ダッシュボードでトークンを再発行し、インストール時に入力したトークンと一致しているか確認してください。トークンを再発行した場合は、`/install-plugin supabase @ claude-plugins-official` を再実行してください。

---

### 接続エラー

**ブラウザの Console に「Invalid API key」と表示される場合:**

`.env.local` の `NEXT_PUBLIC_SUPABASE_ANON_KEY` を確認してください。`anon` キー（`service_role` キーではない）を設定していること、前後に余分なスペースや改行がないことを確認してください。

---

## このチャプターで学んだこと

| 機能 | 体験した内容 |
|------|-------------|
| **プラグイン（外部サービス連携）** | Personal Access Token を取得し `/install-plugin supabase @ claude-plugins-official` で Supabase との接続口を追加した。Claude Code から直接データベースを操作できる状態を作った |
| **DB 設計指示** | 日本語でテーブル要件を伝えるだけで、適切な SQL（RLS ポリシー含む）をプラグイン経由で直接実行してもらえることを体験した |
| **SQL 生成** | 複雑なセキュリティ設定（Row Level Security）も「自分の TODO だけ見れるようにして」という自然な指示で生成・実行できることを体験した |

---

## 次のチャプターへ

Supabase のセットアップが完了しました。

次の **Chapter 4: Vibe Coding で TODO アプリを作る** では、このデータベースと画面を実際につなぎ、TODO の追加・一覧表示・完了切り替え・削除が動く状態にします。さらにログイン機能も組み込み、自分専用のアプリが完成します。
