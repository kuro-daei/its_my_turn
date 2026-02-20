---
title: "Chapter 4: Supabase 初期設定"
parent: カリキュラム
nav_order: 4
---

# Chapter 4: Supabase 初期設定

**所要時間**: 約 30 分
**ゴール**: Supabase のデータベースが立ち上がり、Next.js アプリから接続できる状態にする
**学ぶ Claude Code 機能**: データベース設計の指示、SQL 生成

---

## このチャプターで学ぶこと

- Supabase のアカウントを作成し、プロジェクトを立ち上げる
- `todos` テーブルを Claude Code に設計・SQL 生成させ、ダッシュボードで実行する
- `.env.local` に接続情報を設定する
- Supabase クライアントの初期化ファイルを Claude Code に作成させる
- 動作確認（接続テスト）を行う
- Chapter 0 の「随時追記セクション」を更新する

全部終わったら、Next.js アプリから Supabase のデータベースに接続できる状態になります。

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

[screenshot: supabase.com のトップページ。右上に「Start your project」ボタンが見えている]

[screenshot: サインアップ画面。「Continue with GitHub」ボタンが中央に表示されている]

4. GitHub 連携の場合は「Authorize supabase」をクリックして認証を完了させる

> **なぜ GitHub 連携が便利なの？** 別のパスワードを覚える必要がなく、すでに使っている GitHub アカウントでログインできます。サービス間の連携がスムーズになるため推奨です。

**確認ポイント**

- [ ] Supabase のダッシュボード（`https://supabase.com/dashboard`）にログインできた

---

### 1-2. 新規プロジェクトの作成

ダッシュボードが表示されたら、新しいプロジェクトを作成します。

1. ダッシュボード左上の「New project」ボタンをクリック

[screenshot: Supabase ダッシュボード。「New project」ボタンが左上に表示されている]

2. プロジェクトの設定を入力する

| 項目 | 入力内容 |
|------|---------|
| **Organization** | 自動で作成された組織名のまま（変更不要） |
| **Name** | `its-my-turn`（または任意のプロジェクト名） |
| **Database Password** | 強力なパスワードを入力する（後で必要になるので必ず保存） |
| **Region** | `Northeast Asia (Tokyo)` を選択（日本に近いため表示速度が速い） |
| **Plan** | `Free` のまま |

> **Database Password について**: データベースに直接アクセスするための鍵です。今後使う場面があるため、パスワード管理ツールやメモ帳に必ず記録しておいてください。

[screenshot: 新規プロジェクト作成フォーム。Name、Password、Region の入力欄が並んでいる]

3. 「Create new project」ボタンをクリック

> **注意:** データベースのセットアップには 1〜2 分かかります。「Setting up your project...」という表示が消えるまで待ってください。

[screenshot: プロジェクト作成中のローディング画面]

**確認ポイント**

- [ ] プロジェクトのダッシュボードが表示された（URL が `https://supabase.com/dashboard/project/xxxxxxxxxx` になっている）
- [ ] データベースパスワードを安全な場所に保存した

---

## Step 2: todos テーブルの設計（10分）

### 2-1. Claude Code に SQL を生成させる

> **SQL（エスキューエル）とは？** データベースを操作するための「命令言語」です。「このテーブルを作って」「このデータを追加して」といった指示をデータベースに伝えるために使います。専門的な知識が必要ですが、Claude Code が代わりに書いてくれます。

ターミナルでプロジェクトルートに移動し、Claude Code を起動します。

```bash
cd ~/workspace/its_my_turn
claude
```

Claude Code が起動したら、以下の指示をそのまま貼り付けてください。

> Supabase の `todos` テーブルを設計して SQL を書いて。以下のカラムを含めること:
> - `id`: UUID、主キー、デフォルトは `gen_random_uuid()`
> - `title`: テキスト、NULL 不可
> - `completed`: 真偽値、デフォルトは `false`
> - `created_at`: タイムスタンプ（タイムゾーン付き）、デフォルトは `now()`
> - `user_id`: UUID、`auth.users` テーブルの外部キー
>
> Row Level Security (RLS) を有効化するポリシーも含めて。ログインしたユーザーが自分の TODO だけを見れる・作れる・更新できる・削除できるようにして

> **体験:** データベースの設計は、通常 SQL の知識が必要な専門的な作業です。Claude Code に日本語で「何が必要か」を伝えるだけで、適切な SQL を生成してくれます。RLS（後ほど説明します）のような高度なセキュリティ設定も一緒に生成できます。

### 2-2. 期待される SQL の出力

Claude Code が生成する SQL は以下のようなものになります（多少異なっていても問題ありません）。

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

生成された SQL をターミナルからコピーしておいてください。

---

### 2-3. Supabase の SQL Editor で実行する

> **SQL Editor とは？** Supabase ダッシュボード上でデータベースに命令を送れる画面です。SQL を貼り付けて実行することで、テーブルの作成やデータ操作ができます。

1. Supabase ダッシュボードに戻る
2. 左サイドバーで「SQL Editor」をクリック

[screenshot: Supabase ダッシュボードの左サイドバー。「SQL Editor」メニューアイテムが見えている]

3. 「New query」または「+」ボタンをクリックして新しいクエリを開く

[screenshot: SQL Editor の画面。中央に大きなテキストエリアがあり「New query」ボタンがある]

4. テキストエリアに、Claude Code が生成した SQL をすべて貼り付ける
5. 右上の「Run」ボタン（または `Ctrl + Enter` / `Cmd + Enter`）をクリックして実行する

[screenshot: SQL Editor にコードが貼り付けられ、「Run」ボタンが右上に見えている状態]

6. 下部の結果エリアに「Success. No rows returned」と表示されれば成功

[screenshot: SQL 実行後の結果エリアに「Success. No rows returned」と表示されている様子]

> **「No rows returned」で大丈夫？** はい、これは正常です。「テーブルを作ったけど、まだデータは何も入っていない」という状態です。エラーではなく成功のサインです。

---

### 2-4. テーブルが作成されたことを確認する

1. 左サイドバーの「Table Editor」をクリック
2. `todos` テーブルが一覧に表示されていることを確認する

[screenshot: Table Editor の画面に「todos」テーブルが表示されている様子]

3. `todos` テーブルをクリックして、カラムの構成を確認する

> **カラム（列）とは？** 表でいう「列」にあたるものです。Excel でいえば「氏名」「年齢」「住所」といった列の見出しのような概念です。

[screenshot: todos テーブルの詳細画面。id, title, completed, created_at, user_id の各カラムが表示されている]

**確認ポイント**

- [ ] SQL Editor で SQL が正常に実行できた（エラーが出ていない）
- [ ] Table Editor に `todos` テーブルが表示されている
- [ ] `todos` テーブルに 5 つのカラム（`id`、`title`、`completed`、`created_at`、`user_id`）がある

---

## Step 3: 接続情報の設定（5分）

### 3-1. Supabase の URL と anon key を取得する

> **接続情報とは？** アプリが「どの Supabase プロジェクトに接続するか」を識別するための情報です。家の住所と玄関の鍵のセットのようなもので、URL が住所、anon key が鍵に相当します。

1. Supabase ダッシュボードの左サイドバー下部の歯車アイコン（Settings）をクリック
2. 「API」を選択

[screenshot: Settings メニューの中の「API」項目が選択されている様子]

3. 「Project URL」と「Project API keys」のセクションを見つける
4. 以下の 2 つの値をコピーする

| 項目 | 説明 |
|------|------|
| **Project URL** | `https://xxxxxxxxxx.supabase.co` の形式の URL |
| **anon public** | `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` で始まる長い文字列 |

[screenshot: API 設定ページ。Project URL と anon public キーがそれぞれのコピーボタン付きで表示されている]

> **注意:** `anon` キー（public キー）は画面に公開しても問題ありませんが、`service_role` キー（secret キー）は**絶対に公開しないでください**。今回使うのは `anon` キーのみです。名前が似ているので間違えないよう注意してください。

---

### 3-2. `.env.local` ファイルを作成する

> **`.env.local` って何？** アプリの「秘密のメモ帳」のようなものです。パスワードや接続情報など、他の人に見せたくない設定値を保存するファイルです。このファイルは Git に含まれないため、インターネット上に公開される心配がありません。

ターミナルでプロジェクトルートに移動します。

```bash
cd ~/workspace/its_my_turn
```

テキストエディタで `.env.local` ファイルを新規作成して、以下の内容を記述します。`your-url` と `your-anon-key` の部分を先ほどコピーした実際の値に置き換えてください。

```bash
# .env.local
NEXT_PUBLIC_SUPABASE_URL=https://xxxxxxxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

> **`NEXT_PUBLIC_` って何？** Next.js のルールで、この文字列で始まる変数名は「ブラウザ側のコードからも読み取れる」という意味になります。Supabase の URL と anon key は、ブラウザから直接やりとりするために必要なため、このプレフィックス（接頭語）が付いています。

---

### 3-3. `.gitignore` を確認する

`.env.local` には接続情報が含まれているため、Git に含めてはいけません。プロジェクトルートの `.gitignore`（Git が無視するファイルのリスト）に `.env.local` が含まれていることを確認します。

```bash
cat .gitignore | grep env
```

`.env.local` が出力に含まれていれば OK です。Next.js のデフォルト設定では以下のように記載されているはずです。

```
# local env files
.env*.local
```

> **注意:** `.gitignore` に `.env.local` が含まれていない場合は、必ず追加してください。接続情報が GitHub などに公開されると、データが不正にアクセスされる危険があります。わからない場合はメンターに確認してください。

**確認ポイント**

- [ ] `.env.local` ファイルがプロジェクトルートに作成された
- [ ] `NEXT_PUBLIC_SUPABASE_URL` と `NEXT_PUBLIC_SUPABASE_ANON_KEY` が正しく設定されている
- [ ] `.gitignore` に `.env.local`（または `.env*.local`）が含まれている

---

## Step 4: Supabase クライアントの初期化（10分）

### 4-1. `@supabase/supabase-js` をインストールする

> **パッケージ（ライブラリ）とは？** 他の人が作った便利な機能のセットです。`@supabase/supabase-js` は「Supabase と通信するための道具箱」で、インストールすることで JavaScript から Supabase のデータベースを簡単に操作できるようになります。

ターミナルで以下を実行します。

```bash
cd ~/workspace/its_my_turn
npm install @supabase/supabase-js
```

インストールが完了すると、`package.json`（プロジェクトが使うパッケージの一覧ファイル）の `dependencies` に `@supabase/supabase-js` が追加されます。

**確認コマンド:**

```bash
cat package.json | grep supabase
```

`"@supabase/supabase-js": "^x.x.x"` のような行が表示されれば OK です。

---

### 4-2. Claude Code にクライアント初期化ファイルを作らせる

> **クライアント初期化ファイルって何？** アプリが Supabase と「最初の握手」をするための設定ファイルです。「このアプリはこの Supabase プロジェクトを使います」という宣言を 1 ファイルにまとめておくことで、他のファイルから使いやすくなります。

Claude Code のチャット画面に以下を入力してください。

> Supabase クライアントの初期化ファイルを `src/lib/supabase.ts` に作って。環境変数 `NEXT_PUBLIC_SUPABASE_URL` と `NEXT_PUBLIC_SUPABASE_ANON_KEY` を使って、シングルトンパターンで初期化して

> **体験:** 「どのファイルに」「何のために」「どう実装するか」を日本語で指示するだけでコードが生成されます。「シングルトンパターン」のような技術的なキーワードも理解してくれます。知識がなくても、調べながら指示を出すことで正しいコードが得られます。

### 4-3. 期待されるファイルの内容

Claude Code が生成する `src/lib/supabase.ts` は以下のようになります。

```typescript
// src/lib/supabase.ts
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!

export const supabase = createClient(supabaseUrl, supabaseAnonKey)
```

> **注意:** 実際に Claude Code が生成したファイルを使ってください。上記はあくまでイメージです。TypeScript の型定義や追加のオプション設定が含まれる場合があります。

---

### 4-4. 動作確認（接続テスト）

Supabase クライアントが正しく動作するか確認するため、Claude Code に一時的なテストコードを書いてもらいます。

> `src/lib/supabase.ts` の Supabase クライアントを使って、`todos` テーブルからデータを取得するシンプルな接続テストを書いて。`src/app/page.tsx` の中で確認できるようにして（テスト後は削除するのでコメントアウトでも構わない）

テスト用コードが追加されたら、開発サーバーを起動して確認します。

```bash
npm run dev
```

ブラウザで `http://localhost:3000` を開き、開発者ツール（`F12` キー）を開いて「Console」タブを確認します。

> **ブラウザの開発者ツール（F12）って何？** ウェブサイトの内部状態を確認できる画面です。「Console」タブには、アプリからのメッセージやエラーが表示されます。

[screenshot: ブラウザの開発者ツールの Console タブが開いており、Supabase からのレスポンス（空配列 []）が表示されている様子]

エラーが出ずにレスポンス（テーブルが空であれば `[]`）が表示されれば成功です。

> **`[]` が表示されたら OK？** はい。「Supabase との接続に成功した。ただしテーブルにまだデータが何もない」という意味です。接続自体はうまくいっています。

> **注意:** テスト確認後、追加したテストコードは削除してください。Claude Code に「追加したテストコードを削除して元に戻して」と指示すれば戻してくれます。

**確認ポイント**

- [ ] `src/lib/supabase.ts` が作成されている
- [ ] 開発サーバーがエラーなく起動した
- [ ] ブラウザの Console にエラーが表示されていない（Supabase への接続が成功している）

---

## Step 5: Chapter 0 の「随時追記セクション」を更新する

このチャプターで行った作業（Supabase アカウント作成、パッケージインストール）を Chapter 0 の「随時追記セクション」に記録します。

### Claude Code への指示

> `docs/curriculum/chapter-00-setup.md` の「Supabase アカウント + supabase-js（Chapter 4 で追加）」セクションを更新して。以下の内容を追記して:
> - Supabase アカウントの作成済み（https://supabase.com でアカウント登録）
> - プロジェクト `its-my-turn` 作成済み
> - `@supabase/supabase-js` のインストール: `npm install @supabase/supabase-js`
> - 環境変数 `NEXT_PUBLIC_SUPABASE_URL` / `NEXT_PUBLIC_SUPABASE_ANON_KEY` を `.env.local` に設定済み

> **体験:** ドキュメントの更新も Claude Code に任せられます。「何を記録するか」を指示するだけで、既存のドキュメント形式に合わせて追記してくれます。

**確認ポイント**

- [ ] `chapter-00-setup.md` の Supabase セクションが更新されている

---

## チャプター全体の確認ポイント

このチャプターの全作業が終わったら、以下をまとめて確認してください。

- [ ] Supabase プロジェクトが作成されている
- [ ] Supabase の Table Editor に `todos` テーブルが存在する
- [ ] `.env.local` に `NEXT_PUBLIC_SUPABASE_URL` と `NEXT_PUBLIC_SUPABASE_ANON_KEY` が設定されている
- [ ] `src/lib/supabase.ts` が作成されている
- [ ] 開発サーバーが正常に起動し、Supabase への接続でエラーが出ない
- [ ] `npm run build` がエラーなく完了する

```bash
# ビルドエラーがないか確認
npm run build
```

---

## コミット

確認が取れたら、作業内容をコミットします。

> **コミットとは？** その時点のファイルの状態を「セーブポイント」として記録することです。ゲームのセーブのように「この状態に戻れる」記録を残せます。

```bash
# ブランチを確認（feature/ から始まるブランチにいることを確認）
git branch --show-current

# .env.local は絶対に含めないこと！
git add src/lib/supabase.ts package.json package-lock.json

# コミット
git commit -m "feat: add Supabase client initialization"
```

> **注意:** `git add` で `.env.local` を絶対に含めないでください。接続情報が GitHub に公開されてしまいます。`git add src/` のようにまとめて追加する場合も、`git status` で `.env.local` が含まれていないことを確認してください。

---

## トラブルシューティング

### Supabase プロジェクト作成時のエラー

**「Database password is too weak」と表示される場合:**

パスワードに大文字・小文字・数字・記号を組み合わせた 8 文字以上のものを設定してください。例: `MyPass123!`

**プロジェクト作成が何分経っても完了しない場合:**

ブラウザをリロードしてダッシュボードを確認してください。バックグラウンドでセットアップが完了している場合があります。

---

### SQL 実行時のエラー

**「relation "auth.users" does not exist」と表示される場合:**

Supabase の認証機能（Auth）はデフォルトで有効ですが、プロジェクトが完全にセットアップされていない場合に発生します。数分待ってから再度 SQL を実行してください。

**「ERROR: syntax error at or near ...」と表示される場合:**

SQL のコピーが途中で切れた可能性があります。Claude Code から再度 SQL を取得して、最初から貼り直してください。

---

### 接続エラー

**ブラウザの Console に「Invalid API key」と表示される場合:**

`.env.local` の `NEXT_PUBLIC_SUPABASE_ANON_KEY` を確認してください。`anon` キー（`service_role` キーではない）を設定していること、前後に余分なスペースや改行がないことを確認してください。

**「Failed to fetch」または「Network error」と表示される場合:**

- `.env.local` の `NEXT_PUBLIC_SUPABASE_URL` が正しい形式（`https://xxxxxxxxxx.supabase.co`）か確認してください
- 開発サーバーを一度停止（`Ctrl + C`）してから再起動してください。`.env.local` の変更は再起動後に反映されます

> **なぜ再起動が必要なの？** 環境変数（`.env.local` の内容）はサーバー起動時に 1 度だけ読み込まれます。ファイルを変更しても、実行中のサーバーには自動では反映されません。電源を入れ直すイメージです。

**「supabaseUrl is required」と表示される場合:**

`src/lib/supabase.ts` の中で `process.env.NEXT_PUBLIC_SUPABASE_URL` が `undefined`（未定義）になっています。`.env.local` のファイル名が正確か（`.env.local` であって `.env` や `.env.local.txt` ではないか）確認してください。

---

### `npm install` 時のエラー

**「EACCES: permission denied」と表示される場合（Mac）:**

```bash
sudo npm install @supabase/supabase-js
```

`sudo` を付けて再実行してください。

**「Cannot find module '@supabase/supabase-js'」と表示される場合:**

```bash
npm install @supabase/supabase-js
```

インストールが正常に完了しているか確認してから、開発サーバーを再起動してください。

---

## このチャプターで学んだこと

| 機能 | 体験した内容 |
|------|-------------|
| **DB 設計指示** | 日本語でテーブル要件を伝えるだけで、適切な SQL（RLS ポリシー含む）を生成してもらえることを体験した |
| **SQL 生成** | 複雑なセキュリティ設定（Row Level Security）も「自分の TODO だけ見れるようにして」という自然な指示で生成できることを体験した |
| **ファイル生成** | 初期化ファイルのような定型的なコードも、配置場所・実装パターンを指示するだけで生成できることを体験した |

---

## 次のチャプターへ

Supabase のセットアップが完了しました。

次の **Chapter 5: 初期開発** では、このデータベースと画面を実際につなぎ、TODO の追加・一覧表示・完了切り替え・削除が動く状態にします。さらにログイン機能も組み込み、自分専用のアプリが完成します。
