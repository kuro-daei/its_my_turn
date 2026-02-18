# Module 5: 初期開発

**所要時間**: 約 3 時間
**ゴール**: TODO アプリが一通り動く状態にする（CRUD + ログイン認証）
**学ぶ Claude Code 機能**: 統合的な指示、エージェント活用、タスク分解、環境変数管理

---

## このモジュールで学ぶこと

- 「追加・表示・完了切り替え・削除」の CRUD 操作を UI と DB 同時に実装する
- エージェント機能を使って大きなタスクを分解しながら進める
- Supabase Auth でログイン認証を組み込む
- RLS（Row Level Security）を設定して「自分の TODO だけ見える」状態にする
- 完成したアプリを通しで動作確認してコミットする

全部終わったら、ログインした自分だけが操作できる TODO アプリが動く状態になります。

---

このモジュールでは「画面とデータベースを一気につなぐ」体験をします。

これまでのモジュールで Next.js アプリと Supabase が接続され、UI（ユーザーインターフェース。画面のこと）のモックコンポーネント（見た目だけのパーツ）が揃っています。Module 5 では、それらに「本物のデータと認証」を一気に繋ぎこみます。

> **CRUD（クラッド）とは？** Create（作る）・Read（読む）・Update（更新する）・Delete（消す）の頭文字を取った言葉です。TODO アプリの基本操作「追加・表示・完了切り替え・削除」がちょうどこの 4 つにあたります。

**3つのステップの流れ:**

```
Step 1: TODO の CRUD を UI と DB 同時に作る（1.5時間）
Step 2: SPA 認証を組み込む（1時間）
Step 3: 通し確認 & 初期開発コミット（30分）
```

> **体験:** 「AddTodoForm にフォームを作って」「Supabase に保存して」と別々に指示するのではなく、「AddTodoForm から TODO を追加して Supabase に保存できるようにして」と一度に指示します。これが「統合的な指示」です。画面とデータベースをまたぐ指示でも、Claude Code はコンテキスト（文脈）を保ちながら両方を同時に実装します。

間違えても大丈夫です。途中でわからなくなったら、すぐメンターに声をかけてください。

---

## 事前確認

作業を始める前に、以下を確認してください。

- [ ] Module 0〜4 が完了している
- [ ] Supabase の `todos` テーブルが作成済みである
- [ ] `.env.local` に Supabase の URL と ANON KEY が設定済みである
- [ ] `src/components/` に `Header.tsx`、`TodoList.tsx`、`TodoItem.tsx`、`AddTodoForm.tsx` が存在する
- [ ] 現在のブランチを確認する

```bash
git branch --show-current
```

> **注意:** `main` と表示された場合は、以下のコマンドで作業ブランチを作成してから進めてください。`main` ブランチは「完成品の棚」のようなもので、直接触るのはルール上禁止されています。

```bash
git checkout -b feature/initial-development
```

---

## Step 1: TODO CRUD を UI と DB 同時に作る（1.5時間）

### このステップの目的

「TODO を追加する」「一覧を表示する」「完了を切り替える」「削除する」という 4 つの CRUD 操作を、UI（React。画面側）と DB（Supabase。データ保存側）を分けずに機能単位で一気に実装します。

> **体験:** 従来の開発では「まず API を作る」「次に画面を繋ぐ」と分割して進めていました。Claude Code では「この機能を動くようにして」という一言で、画面とデータベースの両方を同時に実装できます。

---

### Phase A: 追加機能（TODO を作る）

#### Claude Code への指示

> AddTodoForm から新しい TODO を追加できるようにして。テキストを入力して送信すると、Supabase の todos テーブルに保存されて、フォームがリセットされるようにして

[screenshot: Claude Code がコードを生成している様子。AddTodoForm.tsx と Supabase の操作が同時に行われている]

#### 実装で変わるファイルの概要

Claude Code は主に以下の変更を加えます。

**`src/components/AddTodoForm.tsx`**

- `useState`（ステートを管理する仕組み）でフォームの入力値を管理する state を追加
- Supabase クライアントをインポートして `insert`（挿入）操作を追加
- フォーム送信時に Supabase へデータを保存し、フォームをリセットする

```tsx
// AddTodoForm.tsx のイメージ（実際のコードは Claude Code が生成します）
"use client";
import { useState } from "react";
import { createClient } from "@/lib/supabase/client";

export default function AddTodoForm() {
  const [text, setText] = useState("");

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!text.trim()) return;
    const supabase = createClient();
    await supabase.from("todos").insert({ title: text });
    setText("");
  };

  return (
    <form onSubmit={handleSubmit}>
      <input value={text} onChange={(e) => setText(e.target.value)} />
      <button type="submit">追加</button>
    </form>
  );
}
```

> **注意:** 上記はイメージコードです。Claude Code が生成した実際のコードをそのまま使ってください。カラム名（`title` など）は、Module 4 で作成した `todos` テーブルの構造に合わせて変わります。

#### 動作確認方法

1. ブラウザで `http://localhost:3000` を開く
2. テキスト欄に「テスト TODO」と入力して「追加」ボタンを押す
3. Supabase のダッシュボード（`Table Editor` → `todos`）を開いて行が追加されていることを確認する

[screenshot: Supabase の Table Editor に「テスト TODO」の行が追加されている様子]

#### 確認ポイント

- [ ] フォームにテキストを入力して送信できる
- [ ] 送信後にフォームがリセットされる（入力欄が空になる）
- [ ] Supabase の `todos` テーブルにデータが追加されている
- [ ] 空のテキストを送信してもデータが追加されない

#### トラブルシュート

**送信しても Supabase にデータが入らない場合:**

Claude Code に以下のように聞いてみてください。

> AddTodoForm の送信処理でエラーが出ていないか確認して。Supabase のエラーレスポンスをコンソールに出力して

ブラウザの開発者ツール（F12 → Console タブ）でエラーメッセージを確認します。

**よくあるエラーとその原因:**

```
Error: Invalid API key
```

`.env.local` の `NEXT_PUBLIC_SUPABASE_ANON_KEY` が正しくない可能性があります。Supabase ダッシュボード（Settings → API）で確認してください。

```
Error: relation "todos" does not exist
```

`todos` テーブルが作成されていないか、テーブル名が間違っています。Module 4 に戻って確認してください。

---

### Phase B: 一覧表示機能（TODO を読む）

#### Claude Code への指示

> TodoList で Supabase から todos を取得して表示して。ページを開いたときに自動で読み込まれるようにして

[screenshot: Claude Code が TodoList.tsx を編集している様子]

#### 実装で変わるファイルの概要

**`src/components/TodoList.tsx`**

- `useEffect`（コンポーネントが表示されたときに処理を実行する仕組み）を使ってマウント時に Supabase から `todos` を取得
- 取得したデータを `useState` で管理して画面に表示

**`src/app/page.tsx`（または親コンポーネント）**

- `TodoList` に todos データを渡す props（コンポーネント間でデータを渡す仕組み）の調整（実装パターンによる）

#### リアルタイム更新 vs ページリロード

Claude Code がリアルタイム更新（Supabase Realtime。データが変わると自動で画面も更新される機能）を実装するか、手動リフレッシュを選ぶかはプロンプトによって変わります。このモジュールでは「追加後に一覧が更新される」動作を優先します。

追加後に一覧を更新するには、以下を追加で指示します。

> TODO を追加した後、TodoList の一覧が自動で更新されるようにして

#### 動作確認方法

1. ブラウザで `http://localhost:3000` を開く
2. Phase A で追加した「テスト TODO」が一覧に表示されていることを確認する
3. 新しい TODO を追加して、一覧に即座に反映されることを確認する

[screenshot: TodoList に複数の TODO が表示されている様子]

#### 確認ポイント

- [ ] ページを開いたときに既存の todos が表示される
- [ ] 新しい TODO を追加すると一覧に反映される
- [ ] todos が 0 件のときに「TODO はまだありません」などのメッセージが表示される
- [ ] ローディング中に読み込み中のインジケーターが表示される（任意）

#### トラブルシュート

**一覧が空になる（データが取れない）場合:**

> TodoList で Supabase から取得したデータをコンソールに出力して、何が返ってきているか確認して

Supabase ダッシュボードで RLS（Row Level Security。Module 4 で設定したセキュリティ機能）が有効になっていて、かつ認証なしでは読めないポリシーが設定されている場合は Step 2 の認証実装後に再確認します。

---

### Phase C: 完了切り替え機能（TODO を更新する）

#### Claude Code への指示

> TodoItem のチェックボックスをクリックすると completed の状態が切り替わるようにして。Supabase の todos テーブルも更新されるようにして

#### 実装で変わるファイルの概要

**`src/components/TodoItem.tsx`**

- チェックボックスの `onChange` ハンドラ（変更を検知する仕組み）で Supabase の `update` を呼び出す
- `completed`（完了済みかどうか）が `true` のときはテキストに打ち消し線を表示する

```tsx
// TodoItem.tsx のイメージ（実際のコードは Claude Code が生成します）
const handleToggle = async () => {
  const supabase = createClient();
  await supabase
    .from("todos")
    .update({ completed: !todo.completed })
    .eq("id", todo.id);
};
```

#### 動作確認方法

1. 一覧に表示された TODO のチェックボックスをクリックする
2. チェックが入り、テキストに打ち消し線が表示されることを確認する
3. Supabase の `todos` テーブルで `completed` カラムが `true` に変わっていることを確認する
4. もう一度クリックすると元に戻ることを確認する

[screenshot: チェック済みの TODO がグレーアウトされ、打ち消し線が表示されている様子]

#### 確認ポイント

- [ ] チェックボックスをクリックすると視覚的に変化する（打ち消し線など）
- [ ] Supabase の `completed` カラムが更新される
- [ ] ページをリロードしても完了状態が保持されている

---

### Phase D: 削除機能（TODO を消す）

#### Claude Code への指示

> TodoItem の削除ボタンをクリックすると、その TODO が Supabase から削除されて一覧からも消えるようにして

#### 実装で変わるファイルの概要

**`src/components/TodoItem.tsx`**

- 削除ボタンの `onClick` ハンドラで Supabase の `delete` を呼び出す
- 削除後に親コンポーネントに通知して一覧を更新する（コールバック props）

```tsx
// TodoItem.tsx のイメージ（実際のコードは Claude Code が生成します）
const handleDelete = async () => {
  const supabase = createClient();
  await supabase.from("todos").delete().eq("id", todo.id);
  onDelete(todo.id); // 親コンポーネントに通知
};
```

#### 動作確認方法

1. 削除ボタンをクリックする
2. 該当の TODO が一覧から消えることを確認する
3. Supabase の `todos` テーブルから行が削除されていることを確認する

[screenshot: 削除ボタンをクリックした後、一覧から TODO が消えた様子]

#### 確認ポイント

- [ ] 削除ボタンをクリックすると一覧からリアルタイムに消える
- [ ] Supabase の `todos` テーブルから行が削除されている
- [ ] 削除後も他の TODO は影響を受けない

#### Step 1 完了時の確認ポイント

- [ ] TODO の追加が動作する
- [ ] TODO の一覧表示が動作する
- [ ] TODO の完了切り替えが動作する
- [ ] TODO の削除が動作する
- [ ] `npm run build` がエラーなく完了する

```bash
npm run build
```

---

## Step 2: SPA 認証を組み込む（1時間）

### このステップの目的

「誰でも TODO を見られる」状態から「ログインしたユーザーだけが自分の TODO を操作できる」状態に変えます。

> **SPA（エスパー）とは？** Single Page Application の略です。ページ遷移のたびに画面全体を読み込み直すのではなく、必要な部分だけを動的に更新するアプリの仕組みです。現代のウェブアプリのほとんどがこの方式を採用しています。

> **体験:** ここでは Claude Code の「エージェント（Task tool）」機能を使います。「SPA 認証を実装して」という大きな指示を出すと、Claude Code が内部でタスクを分解してサブエージェントを使いながら実装を進めます。最初に手順を確認してみましょう。

---

### Phase A: 計画を立てる（エージェント活用）

まず Claude Code に「まず何をすべき？」と聞いてみます。

> Supabase Auth で SPA ベースのログイン認証を実装したい。まず何をすべきか手順を教えて

Claude Code から以下のような計画が返ってきます。

---

**期待される応答の概要:**

```
Supabase Auth の SPA 認証を実装するには、以下の手順が必要です。

1. @supabase/ssr パッケージのインストール
2. Supabase クライアントの設定（ブラウザ用・サーバー用）
3. ログイン・サインアップ画面の作成
4. 認証状態に基づくリダイレクト処理（Middleware）
5. ログアウト機能の追加
6. RLS（Row Level Security）の設定（自分の TODO のみ操作可能に）

まず @supabase/ssr をインストールしてよいですか？
```

---

> **体験:** Claude Code が大きなタスクを小さなステップに分解しました。「まず何をすべきか」と聞くことで、実装前に全体の見通しを立てることができます。チームメンバーに相談するような感覚で使えます。

[screenshot: Claude Code がタスクを段階的に説明している様子]

---

### Phase B: パッケージインストール

#### Claude Code への指示

> @supabase/ssr をインストールして

```bash
# Claude Code が実行するコマンド
npm install @supabase/ssr
```

> **`@supabase/ssr` って何？** SSR（サーバーサイドレンダリング）対応の Supabase ライブラリです。Next.js の App Router は「サーバー側でも動く」という特性があり、通常の Supabase クライアントではうまく認証情報を扱えません。このパッケージがその問題を解決してくれます。

#### 確認ポイント

- [ ] `package.json` の dependencies に `@supabase/ssr` が追加されている

---

### Phase C: 認証フローの実装

#### Claude Code への指示

> Supabase Auth で SPA ベースのログイン認証を実装して。メールアドレスとパスワードでログイン・サインアップできるようにして。未ログインの場合は /login にリダイレクトして

[screenshot: Claude Code が複数のファイルを同時に生成・編集している様子]

#### 実装で作られるファイルの概要

Claude Code は以下のファイルを作成・更新します。

**`src/lib/supabase/client.ts`（更新）**

ブラウザ（クライアントサイド）用の Supabase クライアント。

**`src/lib/supabase/server.ts`（作成）**

サーバーサイド（Server Components、Route Handlers）用の Supabase クライアント。

**`src/middleware.ts`（作成）**

> **Middleware（ミドルウェア）って何？** リクエストが来るたびに「まず通る関所」のようなものです。ユーザーがどのページを開こうとしても、まずここを通ります。「ログインしていますか？していなければログイン画面へどうぞ」という判断をここで行います。

```typescript
// middleware.ts のイメージ（実際のコードは Claude Code が生成します）
import { createServerClient } from "@supabase/ssr";
import { NextResponse } from "next/server";
import type { NextRequest } from "next/server";

export async function middleware(request: NextRequest) {
  // セッションを確認して未認証なら /login にリダイレクト
}

export const config = {
  matcher: ["/((?!login|_next/static|_next/image|favicon.ico).*)"],
};
```

**`src/app/login/page.tsx`（作成）**

ログイン・サインアップ画面。

**`src/app/auth/callback/route.ts`（作成）**

OAuth（外部サービスを使ったログイン）や Magic Link（メールのリンクでログインする方式）の認証コールバックを処理するルート。

#### ログイン・サインアップ画面の構成

ログイン画面には以下の要素が含まれます。

```
┌─────────────────────────┐
│       TODO アプリ        │
│                         │
│  メールアドレス           │
│  [___________________]  │
│                         │
│  パスワード              │
│  [___________________]  │
│                         │
│  [    ログイン    ]      │
│                         │
│  アカウントをお持ちでない方 │
│  [  サインアップ  ]      │
└─────────────────────────┘
```

[screenshot: ブラウザに表示されたログイン画面]

#### 確認ポイント

- [ ] `http://localhost:3000` にアクセスすると `/login` にリダイレクトされる
- [ ] ログイン画面にメールアドレスとパスワードの入力欄がある
- [ ] `src/middleware.ts` が作成されている
- [ ] `src/app/login/page.tsx` が作成されている

#### トラブルシュート

**リダイレクトが無限ループする場合:**

Middleware のマッチャー設定で `/login` 自体が対象になっている可能性があります。

> middleware.ts の matcher が /login を除外しているか確認して。無限リダイレクトが起きている

---

### Phase D: 認証状態管理とログアウト機能

#### Claude Code への指示

> ログインしたら TODO リスト画面が表示されるようにして。ヘッダーにログアウトボタンを追加して、クリックするとログアウトしてログイン画面に戻るようにして

#### 実装で変わるファイルの概要

**`src/components/Header.tsx`（更新）**

- ログアウトボタンを追加
- ログインユーザーのメールアドレスを表示（任意）

**`src/app/page.tsx`（更新）**

- 認証済みユーザーの情報を取得。未認証の場合は Middleware がリダイレクトを担当するため、ページ自体はシンプルに保つ

```tsx
// Header.tsx のイメージ（実際のコードは Claude Code が生成します）
"use client";
import { createClient } from "@/lib/supabase/client";
import { useRouter } from "next/navigation";

export default function Header() {
  const router = useRouter();
  const supabase = createClient();

  const handleLogout = async () => {
    await supabase.auth.signOut();
    router.push("/login");
  };

  return (
    <header>
      <h1>TODO アプリ</h1>
      <button onClick={handleLogout}>ログアウト</button>
    </header>
  );
}
```

#### 確認ポイント

- [ ] ログイン後に TODO リスト画面が表示される
- [ ] ヘッダーにログアウトボタンがある
- [ ] ログアウトボタンをクリックするとログイン画面に戻る
- [ ] ログアウト後に TODO リスト画面（`/`）に直接アクセスすると `/login` にリダイレクトされる

---

### Phase E: RLS（Row Level Security）の設定

#### このフェーズの目的

現在の状態では、ログインしていれば全ユーザーの TODO が見えてしまいます。RLS を設定することで「自分の TODO だけが見える」ようにします。

> **改めて RLS のイメージ:** マンションのポストのようなものです。101号室の住人は自分のポスト（101）にしかアクセスできない。他の部屋のポストは見えない・触れない。これが RLS です。

> **体験:** セキュリティの設定も Claude Code に頼めます。「自分の TODO だけ見えるようにして」という要件を伝えるだけで、Supabase の RLS ポリシーの SQL を生成してくれます。

#### Claude Code への指示

> Supabase の todos テーブルに RLS を設定して。ログインしているユーザーが自分の TODO だけ作成・読み取り・更新・削除できるようにして

#### 期待される SQL ポリシー

Claude Code は以下のような SQL を生成します。Supabase の SQL Editor で実行するよう指示されます。

```sql
-- RLS を有効化
ALTER TABLE todos ENABLE ROW LEVEL SECURITY;

-- todos テーブルに user_id カラムを追加（未追加の場合）
ALTER TABLE todos ADD COLUMN IF NOT EXISTS user_id UUID REFERENCES auth.users(id);

-- SELECT ポリシー: 自分の TODO のみ読み取り可能
CREATE POLICY "Users can view their own todos"
  ON todos FOR SELECT
  USING (auth.uid() = user_id);

-- INSERT ポリシー: 自分の user_id で TODO を追加可能
CREATE POLICY "Users can insert their own todos"
  ON todos FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- UPDATE ポリシー: 自分の TODO のみ更新可能
CREATE POLICY "Users can update their own todos"
  ON todos FOR UPDATE
  USING (auth.uid() = user_id);

-- DELETE ポリシー: 自分の TODO のみ削除可能
CREATE POLICY "Users can delete their own todos"
  ON todos FOR DELETE
  USING (auth.uid() = user_id);
```

> **注意:** 上記の SQL はイメージです。Claude Code が生成した SQL をそのまま使ってください。`todos` テーブルに `user_id` カラムがすでに存在する場合は `ADD COLUMN` の行は不要です。

[screenshot: Supabase の SQL Editor に RLS ポリシーの SQL が入力されている様子]

#### SQL の実行手順

1. Supabase ダッシュボードを開く
2. 左メニューから「SQL Editor」を選択する
3. Claude Code が生成した SQL をコピーして貼り付ける
4. 「Run」ボタンをクリックして実行する

[screenshot: Supabase の SQL Editor でポリシーが正常に実行された様子]

#### user_id を保存するように AddTodoForm を更新する

RLS を設定したら、TODO 追加時に `user_id`（ユーザーを識別する番号）を保存するよう修正が必要です。

> AddTodoForm で TODO を追加するとき、ログインユーザーの user_id も一緒に保存するようにして

```tsx
// AddTodoForm.tsx のイメージ（実際のコードは Claude Code が生成します）
const handleSubmit = async (e: React.FormEvent) => {
  e.preventDefault();
  const supabase = createClient();
  const { data: { user } } = await supabase.auth.getUser();
  await supabase.from("todos").insert({
    title: text,
    user_id: user?.id,
  });
  setText("");
};
```

#### 確認ポイント

- [ ] Supabase の `todos` テーブルで RLS が有効になっている
- [ ] Supabase の Authentication → Policies で 4 つのポリシーが表示されている
- [ ] TODO 追加時に `user_id` が保存されている
- [ ] 別のユーザーでログインすると、それぞれ自分の TODO だけが表示される（Step 3 で確認）

#### トラブルシュート

**RLS 設定後に TODO が表示されなくなった場合:**

RLS が有効になったことで、`user_id` が設定されていない古い todos が取得できなくなっている可能性があります。Supabase の Table Editor で古い todos を削除するか、`user_id` を設定してください。また、SELECT ポリシーが正しく設定されているか確認します。

> Supabase の todos テーブルで RLS 設定後にデータが取れなくなった。SELECT ポリシーが正しいか確認して

**「permission denied for table todos」エラーが出る場合:**

RLS が有効なのにポリシーが設定されていない状態です。上記の SQL を Supabase の SQL Editor で実行してください。

---

## Step 3: 通し確認 & 初期開発コミット（30分）

### テストシナリオ

以下のチェックリストを上から順番に実行して、アプリが正常に動作することを確認します。

> **注意:** 開発サーバーが起動していない場合は、別のターミナルで `npm run dev` を実行してください。Claude Code のターミナルとは別のターミナルを使うことを推奨します。

---

#### シナリオ 1: サインアップで新規ユーザーを作成する

- [ ] `http://localhost:3000` にアクセスする → `/login` にリダイレクトされる
- [ ] 「サインアップ」ボタンまたはリンクをクリックする
- [ ] 新しいメールアドレスとパスワード（8文字以上）を入力して送信する
- [ ] サインアップ確認メールが届く（または自動ログインされる）

[screenshot: サインアップ成功後の画面。または確認メールの案内が表示されている様子]

> **注意:** Supabase のデフォルト設定では「メール確認」が必要です。確認メールのリンクをクリックしてから次のステップに進んでください。
>
> 開発中にメール確認を無効にする場合: Supabase ダッシュボード → Authentication → Settings → 「Confirm email」をオフ

---

#### シナリオ 2: ログインする

- [ ] メールアドレスとパスワードを入力して「ログイン」をクリックする
- [ ] TODO リスト画面（`http://localhost:3000`）に遷移する
- [ ] ヘッダーにログアウトボタンが表示されている

[screenshot: ログイン後の TODO リスト画面。ヘッダーにログアウトボタンが表示されている]

---

#### シナリオ 3: TODO を追加する

- [ ] テキスト欄に「買い物に行く」と入力して「追加」ボタンをクリックする
- [ ] 「買い物に行く」が一覧に表示される
- [ ] Supabase の `todos` テーブルに行が追加され、`user_id` が設定されている

---

#### シナリオ 4: TODO 一覧に表示される

- [ ] 追加した「買い物に行く」が TodoList に表示されている
- [ ] ページをリロードしても「買い物に行く」が表示されている

---

#### シナリオ 5: TODO の完了を切り替える

- [ ] 「買い物に行く」のチェックボックスをクリックする
- [ ] テキストに打ち消し線が表示される（完了状態になる）
- [ ] もう一度クリックすると打ち消し線が消える（未完了に戻る）

---

#### シナリオ 6: TODO を削除する

- [ ] 「買い物に行く」の削除ボタンをクリックする
- [ ] 一覧から「買い物に行く」が消える

---

#### シナリオ 7: ログアウトする

- [ ] ヘッダーの「ログアウト」ボタンをクリックする
- [ ] ログイン画面（`/login`）にリダイレクトされる
- [ ] ログアウト後に `http://localhost:3000` に直接アクセスすると `/login` にリダイレクトされる

---

#### シナリオ 8: 再ログインで TODO が残っている

- [ ] 同じメールアドレスとパスワードで再ログインする
- [ ] シナリオ 3 で追加した TODO は削除したので、一覧が空になっている（正常）
- [ ] 新しい TODO を追加して、ログアウト → ログインを繰り返してもデータが保持されることを確認する

[screenshot: 再ログイン後に TODO が表示されている様子]

---

### ビルドチェック

コミット前に、ビルドエラーがないことを確認します。

```bash
npm run build
```

以下のような出力が出ればビルド成功です。

```
▲ Next.js 15.x.x

✓ Compiled successfully
✓ Linting and checking validity of types

Route (app)                  Size     First Load JS
┌ ○ /                        ...
└ ○ /login                   ...
```

> **注意:** ビルドエラーが出た場合は、Claude Code に以下のように指示してください。
>
> `npm run build` でエラーが出た。エラーメッセージを読んで修正して

---

### Git コミット

テストとビルドが通ったら、作業内容をコミットします。

#### Claude Code への指示

> 今回の変更をコミットして。Conventional Commits 形式で

Claude Code は以下のような手順でコミットを行います。

```bash
# 変更ファイルを確認
git status

# 変更をステージング
git add .

# コミット（Claude Code がメッセージを自動生成）
git commit -m "feat: implement todo CRUD and Supabase Auth with RLS"
```

> **Conventional Commits って何？** コミットメッセージの「書き方のルール」です。`feat:`（新機能）、`fix:`（バグ修正）、`docs:`（ドキュメント）など、変更の種類をプレフィックス（先頭の文字列）で表現します。例: `feat: ログイン機能を追加`

> **体験:** 「コミットして」と一言指示するだけで、Claude Code は変更内容を把握した上で適切な Conventional Commits 形式のメッセージを生成します。何をコミットするかの説明を別途書く必要はありません。

[screenshot: Claude Code がコミットメッセージを自動生成してコミットしている様子]

#### 確認ポイント

- [ ] `git log --oneline` でコミットが記録されている
- [ ] コミットメッセージが `feat:` で始まる Conventional Commits 形式になっている
- [ ] `git branch --show-current` で `feature/initial-development` ブランチにいることを確認

---

## モジュール全体の確認ポイント

このモジュールの全作業が終わったら、以下をまとめて確認してください。

- [ ] TODO の追加・一覧表示・完了切り替え・削除がすべて動作する
- [ ] ログイン・サインアップ・ログアウトが動作する
- [ ] 未認証の場合に `/login` にリダイレクトされる
- [ ] RLS が設定されており、自分の TODO のみ操作できる
- [ ] `npm run build` がエラーなく完了する
- [ ] `feature/initial-development` ブランチでコミットされている

---

## このモジュールで学んだこと

| 機能 | 体験した内容 |
|------|-------------|
| **統合的な指示** | 「画面とデータベースを同時に実装して」という指示で、UI と DB 操作を一気に実装できることを体験した |
| **エージェント活用** | 「まず何をすべき？」と聞くことで、Claude Code がタスクを分解して手順を提示することを体験した |
| **タスク分解** | 大きな実装タスク（SPA 認証）を Claude Code が自動的に段階に分解して進めることを体験した |
| **環境変数管理** | `.env.local` の Supabase 設定を活用して、認証フローが動くことを体験した |
| **RLS 設定** | SQL を直接書かなくても、要件を伝えるだけで Supabase のセキュリティポリシーを設定できることを体験した |

---

## 次のモジュールへ

初期開発が完成しました。TODO アプリとして一通りの機能が動く状態になっています。

次の **Module 6: Git ワークフロー** では、「動くアプリをさらに良くする」プロセスを体験します。Claude Code にコードのレビューをしてもらい、問題点を修正したり、見た目を改善したりします。ブランチを使った安全な開発の進め方も身につきます。
