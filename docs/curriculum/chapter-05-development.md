---
title: "Chapter 5: Vibe Coding で TODO アプリを作る"
parent: カリキュラム
nav_order: 5
---

# Chapter 5: Vibe Coding で TODO アプリを作る

**所要時間**: 約 3 時間
**ゴール**: TODO アプリが一通り動く状態にする（UI + CRUD + Google ログイン）
**学ぶ Claude Code 機能**: Plan Mode、マルチファイル生成、統合的な指示、タスク分解

---

## このチャプターで学ぶこと

- Vibe Coding という開発スタイルを実感する
- Claude Code の Plan Mode を使って「作る前に設計する」習慣を身につける
- 1 つの指示で複数のファイルを同時に生成する体験をする
- TODO の「追加・表示・完了切り替え・削除」の CRUD 操作を機能単位で実装する
- Google ログインによる認証を組み込み、自分だけの TODO アプリを完成させる
- RLS でデータを守る重要性を実例から学ぶ

全部終わったら、Google でログインした自分だけが操作できる TODO アプリが動く状態になります。

---

## Vibe Coding って何だろう？

「Vibe Coding（バイブ コーディング）」という言葉を聞いたことがありますか？

これは 2025 年に流行した言葉で、あの Collins Dictionary（イギリスの老舗辞書）の「Word of the Year 2025」に選ばれるほど話題になりました。

> **Vibe Coding とは？** AI に自然言語（普通の言葉）で指示するだけで、アプリやウェブサイトを作る開発スタイルのことです。「なんとなく（vibe）」の感覚で、コーディングの専門知識がなくても形にできる、という意味が込められています。

「え、それって私がずっとやってきたことでは？」と思ったなら、その通りです。このカリキュラムで体験してきたことがまさに Vibe Coding です。

料理のたとえでいえば、「パスタが食べたい。トマトベースで」と言えば、シェフ（Claude Code）が献立を考え、材料を揃え、調理してくれる、そんな感覚です。細かいレシピを知らなくても、食べたいものを言葉にするだけでいい。

このチャプターでは Vibe Coding をフルに活用して、TODO アプリを「UI の作成」から「データベース接続」「Google ログイン」まで一気に仕上げます。

間違えても大丈夫です。途中でわからなくなったら、すぐメンターに声をかけてください。

---

## 事前確認

作業を始める前に、以下を確認してください。

- [ ] Chapter 0〜4 が完了している
- [ ] Supabase の `todos` テーブルが作成済みである
- [ ] `.env.local` に Supabase の URL と ANON KEY が設定済みである
- [ ] Google アカウントを持っている
- [ ] 現在のブランチを確認する

```bash
git branch --show-current
```

> **注意:** `main` と表示された場合は、以下のコマンドで作業ブランチを作成してから進めてください。`main` ブランチは「完成品の棚」のようなもので、直接触るのはルール上禁止されています。

```bash
git checkout -b feature/todo-app
```

---

## Step 1: Vibe Coding とは & Plan Mode で設計する（20分）

### このステップの目的

Claude Code の **Plan Mode**（プラン モード）を使って、TODO アプリの設計図を先に作ります。「まず図面を引いてから家を建てる」感覚で、実装前に全体像を確認します。

---

### Plan Mode って何？

通常、Claude Code に指示すると、すぐにコードを書き始めます。Plan Mode はその前に「実装計画を提案して、確認を取ってから実装する」モードです。

**建築のたとえ:** 家を建てるとき、いきなり柱を立て始める職人はいません。まず設計図（間取り図）を作って、住む人に確認してもらいます。OK が出てから工事を始める。Plan Mode はまさにこの「設計図の確認ステップ」です。

設計が間違っていたら実装前に修正できるので、後で大幅に作り直すという手戻りが減ります。

---

### Plan Mode の起動方法

Claude Code のチャット画面で、**`Shift` キーを押しながら `Tab` キーを 2 回押す**と Plan Mode に切り替わります。

入力欄の横や上部に「Plan Mode」と表示されれば切り替え成功です。

[screenshot: Claude Code の Plan Mode が有効になっている様子。入力欄に「Plan Mode」と表示されている]

> **体験:** Plan Mode はいつでも切り替えられます。通常モードに戻すには、再度 `Shift+Tab` × 2 を押してください。

---

### Plan Mode で TODO アプリの設計を依頼する

Plan Mode に切り替えたら、以下の指示を入力してください。

> TODO アプリの画面構成と必要なコンポーネントを設計して。ヘッダー、TODO 追加フォーム、TODO リスト（各アイテムにチェックボックスと削除ボタン）を含めて。Tailwind CSS を使う前提で

Claude Code から以下のような設計案が返ってきます。

---

**期待される応答の概要:**

```
TODO アプリの構成を提案します。

## コンポーネント設計

src/
  components/
    Header.tsx        — アプリタイトル + ログアウトボタン
    AddTodoForm.tsx   — テキスト入力 + 追加ボタン
    TodoItem.tsx      — チェックボックス + タスク名 + 削除ボタン
    TodoList.tsx      — TodoItem の一覧表示
  app/
    page.tsx          — 全コンポーネントを組み合わせたトップページ
    login/
      page.tsx        — Google ログインボタンのみのシンプルな画面

## 実装の順番

1. まず各コンポーネントをダミーデータで作成
2. Supabase と接続して CRUD を実装
3. Google 認証を追加

この方針で進めてよいですか？
```

---

> **体験:** Claude Code が実装前に「こういう構成で進めようと思うけど、いいですか？」と確認してきました。チームメンバーと相談するような感覚で使えます。

[screenshot: Claude Code が設計案を提示して承認を求めている様子]

### 設計を確認して承認する

提示された設計を確認して、問題なければ「OK」「進めて」などと返信します。変更したい点があれば「ヘッダーにはログイン中のメールアドレスも表示したい」のように追加指示できます。

> **ポイント:** 承認する前に一度立ち止まって、「この構成で TODO アプリが作れるか」をイメージしてみてください。修正は今のうちにするのが一番コストが低いです。

### 確認ポイント

- [ ] Plan Mode に切り替えられた（`Shift+Tab` × 2）
- [ ] Claude Code から設計案が提示された
- [ ] 設計内容を確認して承認した

---

## Step 2: UI を一気に作る（40分）

### このステップの目的

Claude Code に 1 行の指示を出して、TODO アプリの画面パーツ（コンポーネント）を一気に生成します。この時点ではデータベースには接続せず、ダミーデータ（仮のデータ）で表示確認します。

---

### UI 生成を依頼する

Plan Mode を解除して（`Shift` キーを押しながら `Tab` キーを 2 回押すと通常モードに戻ります）、以下の指示を入力してください。

> TODO アプリの UI を作って。ヘッダー（アプリタイトル + ログアウトボタン）、TODO 追加フォーム（テキスト入力 + 追加ボタン）、TODO リスト（各アイテムにチェックボックス + テキスト + 削除ボタン）を含めて。まずはダミーデータで表示して。Tailwind CSS でスタイリングして

[screenshot: Claude Code が複数のファイルを同時に生成している様子]

> **体験:** 1 行の指示で複数のファイルが同時に生成される驚きを体感してください。デザイナーがいなくても、自然言語で UI の要望を伝えれば形になります。これが Vibe Coding の醍醐味です。

---

### 生成されるファイル構成

Claude Code は以下のファイルを作成・更新します。

```
src/
  components/
    Header.tsx        （作成）
    AddTodoForm.tsx   （作成）
    TodoItem.tsx      （作成）
    TodoList.tsx      （作成）
  app/
    page.tsx          （更新: 全コンポーネントを組み合わせ）
```

それぞれのファイルの役割は以下の通りです。

| ファイル | 役割 |
|---------|------|
| `Header.tsx` | アプリタイトルとログアウトボタンを表示する |
| `AddTodoForm.tsx` | テキスト入力欄と「追加」ボタンを持つフォーム |
| `TodoItem.tsx` | 1 件の TODO（チェックボックス + テキスト + 削除ボタン） |
| `TodoList.tsx` | TodoItem を並べて一覧表示する |
| `page.tsx` | 全パーツを組み合わせたトップページ |

---

### 動作確認方法

ファイルが生成されたら、ブラウザで `http://localhost:3000` を確認します。

> **注意:** 開発サーバーが起動していない場合は、Claude Code のターミナルとは**別のターミナル**で `npm run dev` を実行してください。

以下のような画面が表示されれば成功です。

```
┌────────────────────────────────────┐
│  TODO アプリ           [ログアウト] │
├────────────────────────────────────┤
│  [タスクを入力...]       [追加]     │
├────────────────────────────────────┤
│  □ 買い物に行く              [削除] │
│  ☑ メールを返す              [削除] │
│  □ 本を読む                  [削除] │
└────────────────────────────────────┘
```

[screenshot: ブラウザに TODO アプリの UI が表示されている様子。ダミーデータで TODO が 3 件表示されている]

### 確認ポイント

- [ ] `src/components/` に 4 つのファイル（Header.tsx, AddTodoForm.tsx, TodoItem.tsx, TodoList.tsx）が作成された
- [ ] ブラウザでダミーの TODO リストが表示される
- [ ] フォームの入力欄と追加ボタンが見える
- [ ] ヘッダーにアプリタイトルが表示される
- [ ] 各 TODO にチェックボックスと削除ボタンがある

### トラブルシュート

**ブラウザに何も表示されない、またはエラーになる場合:**

```bash
# 開発サーバーが起動しているか確認
# 別ターミナルで実行
npm run dev
```

Claude Code に以下のように聞いてみてください。

> ブラウザで localhost:3000 を開いたらエラーになった。ターミナルのエラーメッセージを確認して修正して

**Tailwind CSS のスタイルが当たっていない場合:**

> Tailwind CSS のスタイルが反映されていない。tailwind.config.ts の設定を確認して

---

## Step 3: CRUD を機能単位で繋ぐ（60分）

### このステップの目的

Step 2 で作ったダミー UI を、Supabase のデータベースに接続して「本物のデータ」で動くようにします。「追加（Create）→ 表示（Read）→ 完了切り替え（Update）→ 削除（Delete）」の順番に、機能ひとつひとつを確認しながら進めます。

この順番には理由があります。まず「追加」がないと表示するデータがない。データがないと「完了切り替え」も「削除」も試せない。だから Create → Read → Update → Delete の順番で進めます。

> **CRUD（クラッド）とは？** Create（作る）・Read（読む）・Update（更新する）・Delete（消す）の頭文字を取った言葉です。TODO アプリの基本操作「追加・表示・完了切り替え・削除」がちょうどこの 4 つにあたります。

> **体験:** 「AddTodoForm にフォームを作って」「Supabase に保存して」と別々に指示するのではなく、「AddTodoForm から TODO を追加して Supabase に保存できるようにして」と一度に指示します。これが「統合的な指示」です。画面とデータベースをまたぐ指示でも、Claude Code はコンテキスト（文脈）を保ちながら両方を同時に実装します。

---

### Phase A: 追加機能（Create）

#### Claude Code への指示

> AddTodoForm から新しい TODO を追加できるようにして。テキストを入力して送信すると、Supabase の todos テーブルに保存されて、フォームがリセットされるようにして

[screenshot: Claude Code が AddTodoForm.tsx を編集している様子]

#### 実装で変わるファイルの概要

Claude Code は主に以下の変更を加えます。

**`src/components/AddTodoForm.tsx`（更新）**

- フォームの入力値を管理する state（ステート。「今この瞬間の値」を保存する仕組み。入力欄に何が書かれているかを覚えておくために使います）を追加
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

> **注意:** 上記はイメージコードです。Claude Code が生成した実際のコードをそのまま使ってください。カラム名（`title` など）は、Chapter 4 で作成した `todos` テーブルの構造に合わせて変わります。

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

`todos` テーブルが作成されていないか、テーブル名が間違っています。Chapter 4 に戻って確認してください。

---

### Phase B: 一覧表示機能（Read）

#### Claude Code への指示

> TodoList で Supabase から todos を取得して表示して。ページを開いたときに自動で読み込まれるようにして

[screenshot: Claude Code が TodoList.tsx を編集している様子]

#### 実装で変わるファイルの概要

**`src/components/TodoList.tsx`（更新）**

- ページ表示時に Supabase から `todos` を取得する
- 取得したデータを state で管理して画面に表示する

追加後に一覧を自動更新するには、以下を追加で指示します。

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

#### トラブルシュート

**一覧が空になる（データが取れない）場合:**

> TodoList で Supabase から取得したデータをコンソールに出力して、何が返ってきているか確認して

> **補足:** この時点で RLS（セキュリティ設定）が有効になっていて認証なしでは読めない場合があります。Step 4 の Google ログイン実装後に改めて確認してください。

---

### Phase C: 完了切り替え機能（Update）

#### Claude Code への指示

> TodoItem のチェックボックスをクリックすると completed の状態が切り替わるようにして。Supabase の todos テーブルも更新されるようにして

#### 実装で変わるファイルの概要

**`src/components/TodoItem.tsx`（更新）**

- チェックボックスをクリックした際に Supabase の `update` を呼び出す
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

### Phase D: 削除機能（Delete）

#### Claude Code への指示

> TodoItem の削除ボタンをクリックすると、その TODO が Supabase から削除されて一覧からも消えるようにして

#### 実装で変わるファイルの概要

**`src/components/TodoItem.tsx`（更新）**

- 削除ボタンのクリック時に Supabase の `delete` を呼び出す
- 削除後に親コンポーネントに通知して一覧を更新する

```tsx
// TodoItem.tsx のイメージ（実際のコードは Claude Code が生成します）
const handleDelete = async () => {
  const supabase = createClient();
  await supabase.from("todos").delete().eq("id", todo.id);
  onDelete(todo.id); // 上位の画面（TodoList）に「この TODO は消したよ」と知らせる
};
```

#### 動作確認方法

1. 削除ボタンをクリックする
2. 該当の TODO が一覧から消えることを確認する
3. Supabase の `todos` テーブルから行が削除されていることを確認する

[screenshot: 削除ボタンをクリックした後、一覧から TODO が消えた様子]

#### 確認ポイント

- [ ] 削除ボタンをクリックすると一覧から消える
- [ ] Supabase の `todos` テーブルから行が削除されている
- [ ] 削除後も他の TODO は影響を受けない

---

### Step 3 完了時のビルドチェック

CRUD の 4 機能が揃ったら、ビルドエラーがないか確認します。

> **ビルドって何？** 開発用のコードを「本番公開できる形」に変換する作業です。エラーが出ずに完了すれば、コードに問題がないことが確認できます。料理でたとえると、「試作品を実際にお客さんに出せる品質か最終チェックする」工程です。

```bash
npm run build
```

> **注意:** ビルドエラーが出た場合は、Claude Code に以下のように指示してください。
>
> `npm run build` でエラーが出た。エラーメッセージを読んで修正して

#### 確認ポイント

- [ ] TODO の追加が動作する
- [ ] TODO の一覧表示が動作する
- [ ] TODO の完了切り替えが動作する
- [ ] TODO の削除が動作する
- [ ] `npm run build` がエラーなく完了する

---

## Step 4: Google ログインを組み込む（40分）

### このステップの目的

「誰でも TODO を操作できる」状態から「Google ログインした自分だけが操作できる」状態に変えます。認証（誰がアクセスしているかの確認）は Google ログインのみに絞ります。

> **なぜ認証が必要なの？** 今のアプリは「鍵のかかっていない家」の状態です。誰でも入れて、他の人のデータを見たり削除したりできてしまいます。Google ログインを組み込むことで「この人は本当に自分のアカウントの持ち主か」を確認できるようになります。

> **なぜ Google ログインを選ぶの？** パスワードを別途管理する必要がなく、ほとんどの人が既に使っている Google アカウントでそのままログインできます。「Google でログイン」ボタン 1 つでいい、という体験のシンプルさが非エンジニアにとっても最も馴染みがあります。

---

### Phase A: Claude Code に計画を立てさせる

まず Claude Code に「まず何をすべきか」を聞いてみます。タスクを分解して手順を提示する体験です。

> Supabase Auth で Google ログインを実装したい。まず何をすべきか手順を教えて

Claude Code から以下のような計画が返ってきます。

---

**期待される応答の概要:**

```
Google ログインを実装するには、以下の手順が必要です。

1. Supabase ダッシュボードで Google Provider を有効化
2. @supabase/ssr パッケージのインストール
3. Supabase クライアントの設定（ブラウザ用・サーバー用）
4. ログイン画面の作成（Google でログインボタンのみ）
5. 認証状態に基づくリダイレクト処理（Middleware）
6. OAuth コールバック処理の実装
7. RLS の設定（自分の TODO のみ操作可能に）

まず Supabase ダッシュボードの設定から始めましょうか？
```

---

> **体験:** Claude Code が大きなタスクを小さなステップに分解しました。「まず何をすべきか」と聞くことで、全体の見通しを立ててから進めることができます。

[screenshot: Claude Code がタスクを段階的に提示している様子]

---

### Phase B: Supabase で Google Provider を有効化

Google ログインを使えるようにするには、Supabase 側で「Google を使ったログインを許可する」設定が必要です。

#### 手順

1. Supabase ダッシュボード（`https://supabase.com/dashboard`）を開く
2. 左サイドバーの「Authentication」をクリック
3. 「Providers」タブを選択
4. 「Google」を見つけてクリックして展開する

[screenshot: Supabase の Authentication → Providers 画面。Google の行が見えている]

5. 「Enable Sign in with Google」のトグルをオンにする

[screenshot: Google Provider が有効化されている様子]

6. 「Redirect URLs」の欄に以下を追加する

```
http://localhost:3000/auth/callback
```

> **Redirect URL（リダイレクト URL）って何？** Google でログインが完了したあと、「どの URL に戻るか」を指定する設定です。今は開発環境なので `localhost:3000` を指定しています。

7. 「Save」ボタンをクリックして保存する

> **補足:** Supabase は「Supabase OAuth」というデフォルトの設定を提供しています。Google Cloud Console で自前の OAuth クライアントを取得する必要はなく、この設定だけで Google ログインが使えます（Supabase が仲介してくれます）。

#### 確認ポイント

- [ ] Supabase の Authentication → Providers で Google が有効になっている
- [ ] Redirect URL に `http://localhost:3000/auth/callback` が追加されている

#### Google ログインの全体の流れ

「Google でログイン」ボタンを押してからアプリに戻るまでの流れは以下の通りです。

1. アプリの「Google でログイン」ボタンをクリックする
2. Google のサイトに自動で移動する
3. Google アカウントを選んで「許可」する
4. 自動でアプリに戻ってくる（`/auth/callback` を経由）
5. ログイン完了 → TODO リスト画面が表示される

この流れを実現するために、Phase C で認証フローのコードを作ります。

---

### Phase C: @supabase/ssr のインストールと認証フロー実装

#### @supabase/ssr って何？

> **`@supabase/ssr` とは？** Next.js のような「サーバー側でも動く」フレームワークに対応した Supabase の認証ライブラリです。
>
> 旧バージョンの `@supabase/auth-helpers` は 2025 年 1 月に廃止されました。`@supabase/ssr` がその後継パッケージで、2025 年以降の推奨パターンです。
>
> この新しいライブラリは「Cookie ベース認証」を採用しています。Cookie（クッキー）とはブラウザが保存する小さなメモのようなもので、「このユーザーはログイン済み」という情報をページをまたいで保持するために使われます。

#### パッケージのインストール

Claude Code に以下を指示します。

> @supabase/ssr をインストールして

Claude Code がターミナルで自動実行します。自分でコマンドを入力する必要はありません。

Claude Code が以下のコマンドを実行します。

```bash
npm install @supabase/ssr
```

#### 認証フローの実装

続けて以下を指示します。

> Supabase Auth の Google ログインを実装して。@supabase/ssr を使って。未ログインの場合は /login にリダイレクトして

[screenshot: Claude Code が複数のファイルを同時に生成・編集している様子]

#### 実装で作られるファイルの概要

Claude Code は以下のファイルを作成・更新します。

**`src/lib/supabase/client.ts`（更新）**

ブラウザ（クライアントサイド）用の Supabase クライアント。

**`src/lib/supabase/server.ts`（作成）**

サーバーサイド用の Supabase クライアント。Cookie から認証情報を読み取る。

**`src/middleware.ts`（作成）**

> **Middleware（ミドルウェア）って何？** リクエストが来るたびに「まず通る関所」のようなものです。ユーザーがどのページを開こうとしても、まずここを通ります。「ログインしていますか？していなければログイン画面へどうぞ」という判断をここで行います。

Middleware がないと、未ログインのユーザーが直接 `http://localhost:3000` にアクセスしてメイン画面を開けてしまいます。関所がなければ誰でも素通りできる、という状態です。

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

ログイン画面。「Google でログイン」ボタンのみのシンプルな構成。

```
┌─────────────────────────┐
│                         │
│       TODO アプリ        │
│                         │
│  [G]  Google でログイン  │
│                         │
└─────────────────────────┘
```

**`src/app/auth/callback/route.ts`（作成）**

Google ログイン完了後の処理を受け取るルート。

[screenshot: ブラウザに表示されたログイン画面。「Google でログイン」ボタンだけが中央にある]

#### 確認ポイント

- [ ] `package.json` に `@supabase/ssr` が追加されている
- [ ] `src/middleware.ts` が作成されている
- [ ] `src/app/login/page.tsx` が作成されている
- [ ] `src/app/auth/callback/route.ts` が作成されている
- [ ] `http://localhost:3000` にアクセスすると `/login` にリダイレクトされる
- [ ] ログイン画面に「Google でログイン」ボタンが表示されている

#### トラブルシュート

**リダイレクトが無限ループする場合:**

Middleware のマッチャー設定で `/login` 自体が対象になっている可能性があります。

> middleware.ts の matcher が /login を除外しているか確認して。無限リダイレクトが起きている

**Google ログインボタンを押しても何も起きない場合:**

> /auth/callback/route.ts のコードを確認して。OAuth のコールバック処理が正しく実装されているか確認して

---

### Phase D: RLS の設定

#### なぜ RLS が重要なのか — 実際の事例

2025 年、RLS（Row Level Security。行レベルのセキュリティ）の設定が不十分だったことが原因で、170 以上のアプリが情報漏洩を起こしたという報告があります。「ログインさえしていれば、他人のデータも読めてしまう」という状態が放置されていたのです。

RLS はデータベースの「内側の鍵」です。

- ドア（Google ログイン）だけでは「家の中には入れない」ことは保証できます
- でも家の中の「どの部屋に入れるか」は RLS が制御します
- RLS がなければ、ログインした全員が全員のデータを読み書きできてしまいます

> **マンションのたとえ:** ログイン認証は「マンションの玄関オートロック」です。RLS は「各部屋のドアの鍵」です。玄関を通れても、自分の部屋（101 号室）以外の部屋は開けられない、という仕組みが RLS です。

#### Claude Code への指示

> todos テーブルに RLS を設定して。ログインユーザーが自分の TODO だけ操作できるようにして

#### 期待される SQL ポリシー

Claude Code は以下のような SQL を生成します。Supabase の SQL Editor で実行するよう指示されます。

```sql
-- RLS を有効化（イメージ。実際のコードは Claude Code が生成します）
ALTER TABLE todos ENABLE ROW LEVEL SECURITY;

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

> **`auth.uid()`（オース ユーアイディー）って何？** Supabase がログイン中のユーザーの ID を返す関数です。「このリクエストを送ってきたのは誰か」を Supabase が管理するので、クライアント（ブラウザ）から送られてきた `user_id` を信用する必要がありません。なぜなら、悪意のある人がブラウザで値を書き換えて「自分は別の人です」と偽ることを防げるからです。`auth.uid()` はサーバー側で管理されているため、ブラウザからは書き換えられません。これが重要なセキュリティポイントです。

[screenshot: Supabase の SQL Editor に RLS ポリシーの SQL が入力されている様子]

#### SQL の実行手順

1. Supabase ダッシュボードを開く
2. 左メニューから「SQL Editor」を選択する
3. Claude Code が生成した SQL をコピーして貼り付ける
4. 「Run」ボタンをクリックして実行する

[screenshot: Supabase の SQL Editor でポリシーが正常に実行された様子]

#### TODO 追加時に user_id を保存するよう更新する

Chapter 4 で `todos` テーブルを作ったとき、`user_id` というカラム（「誰のデータか」を記録する列）も一緒に作っていましたね。ここでようやくそのカラムが活躍します。TODO を追加するときに、ログインユーザーの `user_id` も一緒に保存するよう修正します。

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
- [ ] ログイン → TODO 追加 → ログアウト → 再ログインしても自分の TODO だけ表示される

#### トラブルシュート

**RLS 設定後に TODO が表示されなくなった場合:**

RLS が有効になったことで、`user_id` が設定されていない古い todos が取得できなくなっています。Supabase の Table Editor で古いデータを削除するか、`user_id` を手動で設定してください。

> Supabase の todos テーブルで RLS 設定後にデータが取れなくなった。SELECT ポリシーが正しいか確認して

**「permission denied for table todos」エラーが出る場合:**

RLS が有効なのにポリシーが設定されていない状態です。上記の SQL を Supabase の SQL Editor で実行してください。

---

## Step 5: 通し確認 & コミット（20分）

### テストシナリオ

以下の 8 つのシナリオを上から順番に実行して、アプリが正常に動作することを確認します。

> **注意:** 開発サーバーが起動していない場合は、別のターミナルで `npm run dev` を実行してください。

---

#### シナリオ 1: 未ログイン状態でリダイレクトされる

- [ ] `http://localhost:3000` にアクセスすると `/login` にリダイレクトされる
- [ ] ログイン画面に「Google でログイン」ボタンが表示されている

[screenshot: /login ページに「Google でログイン」ボタンだけが表示されている様子]

---

#### シナリオ 2: Google でログインする

- [ ] 「Google でログイン」ボタンをクリックすると Google の認証画面が開く
- [ ] Google アカウントを選択してログインすると TODO リスト画面に遷移する
- [ ] ヘッダーにアプリタイトルとログアウトボタンが表示されている

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
- [ ] Supabase の `todos` テーブルからも行が削除されている

---

#### シナリオ 7: ログアウトする

- [ ] ヘッダーの「ログアウト」ボタンをクリックする
- [ ] ログイン画面（`/login`）にリダイレクトされる
- [ ] ログアウト後に `http://localhost:3000` に直接アクセスすると `/login` にリダイレクトされる

---

#### シナリオ 8: 再ログインで TODO が保持されている

- [ ] 同じ Google アカウントで再ログインする
- [ ] 以前追加した TODO が表示されている（削除した TODO は表示されない）

[screenshot: 再ログイン後に TODO が保持されている様子]

---

#### シナリオ 9: 別のアカウントで確認する（余裕があれば）

別の Google アカウントでログインして、先ほど追加した TODO が見えないことを確認しましょう。

- [ ] 別の Google アカウントでログインする（別のブラウザまたはシークレットウィンドウを使う）
- [ ] 先ほど追加した TODO が表示されないことを確認する
- [ ] 別アカウントで新しい TODO を追加しても、元のアカウントには表示されないことを確認する

> **体験:** これが RLS の効果です。同じアプリを使っていても、自分のデータしか見えません。マンションの各部屋の鍵がしっかりかかっていることを確認できました。

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
├ ○ /login                   ...
└ ○ /auth/callback            ...
```

> **注意:** ビルドエラーが出た場合は、Claude Code に以下のように指示してください。
>
> `npm run build` でエラーが出た。エラーメッセージを読んで修正して

---

### Git コミット

テストとビルドが通ったら、作業内容をコミットします。

#### 事前確認

```bash
# main ブランチにいないことを確認する
git branch --show-current
```

`feature/todo-app`（または作業ブランチ名）と表示されれば OK です。`main` と表示された場合はメンターに声をかけてください。

#### Claude Code への指示

> 今回の変更をコミットして。Conventional Commits 形式で

Claude Code は以下のような手順でコミットを行います。

```bash
# 変更ファイルを確認
git status

# 変更をステージング（.env.local は含めない）
git add src/ package.json package-lock.json

# コミット（Claude Code がメッセージを自動生成）
git commit -m "feat: implement todo app with CRUD and Google authentication"
```

> **Conventional Commits って何？** コミットメッセージの「書き方のルール」です。`feat:`（新機能）、`fix:`（バグ修正）、`docs:`（ドキュメント）など、変更の種類をプレフィックス（先頭の文字列）で表現します。

> **体験:** 「コミットして」と一言指示するだけで、Claude Code は変更内容を把握した上で適切な Conventional Commits 形式のメッセージを生成します。何をコミットするかの説明を別途書く必要はありません。

[screenshot: Claude Code がコミットメッセージを自動生成してコミットしている様子]

#### 確認ポイント

- [ ] `git log --oneline` でコミットが記録されている
- [ ] コミットメッセージが `feat:` で始まる Conventional Commits 形式になっている
- [ ] `git branch --show-current` で `feature/todo-app` ブランチにいることを確認

---

### CLAUDE.md の随時追記セクションを更新する

このチャプターで行った作業を CLAUDE.md の「随時追記」セクションに記録しましょう。Claude Code に以下のように指示します。

> CLAUDE.md の随時追記セクションに、以下を追記して:
> - `@supabase/ssr` を追加インストールした
> - Google ログインを実装した
> - RLS ポリシーを設定した

> **体験:** プロジェクトを進めるたびに気づいたことを CLAUDE.md に記録する習慣が、Claude Code を「育てる」コツです。次に作業するとき、Claude Code はこの記録を読んで文脈を理解してくれます。

---

## チャプター全体の確認ポイント

このチャプターの全作業が終わったら、以下をまとめて確認してください。

- [ ] Plan Mode で設計を確認してから実装を始めた
- [ ] 1 行の指示で複数のコンポーネントファイルが生成された
- [ ] TODO の追加・一覧表示・完了切り替え・削除がすべて動作する
- [ ] `http://localhost:3000` にアクセスすると `/login` にリダイレクトされる
- [ ] Google でログイン・ログアウトが動作する
- [ ] RLS が設定されており、自分の TODO のみ操作できる
- [ ] `npm run build` がエラーなく完了する
- [ ] `feature/todo-app` ブランチでコミットされている

---

## このチャプターで学んだこと

| 機能 | 体験した内容 |
|------|-------------|
| **Vibe Coding** | AI に自然言語で指示するだけでアプリが形になることを実感した。これがまさに今やっていることだと気づいた |
| **Plan Mode** | `Shift+Tab × 2` で設計図を先に作り、確認してから実装する習慣を身につけた |
| **マルチファイル生成** | 1 行の指示で複数のコンポーネントが同時に生成されることを体験した |
| **統合的な指示** | 「画面とデータベースを同時に実装して」という指示で、UI と DB 操作を一気に実装できることを体験した |
| **タスク分解** | 「まず何をすべき？」と聞くことで、Claude Code が大きなタスクを段階的に分解することを体験した |
| **RLS** | 2025 年の実際の漏洩事例を通じて、データセキュリティの重要性を実感した |

---

次のチャプターへ: [Chapter 6: 修正・改善](./chapter-06-git-workflow.md)
