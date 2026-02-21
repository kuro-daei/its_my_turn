# Chapter 5 再設計 — 設計ドキュメント

## 背景

### 問題

- Chapter 3（Figma ベースの UI 作成）が削除されたため、Chapter 5 が前提としていた UI コンポーネント（Header, TodoList, TodoItem, AddTodoForm）が存在しない
- 現行の Chapter 5 は「UI がある前提」で CRUD + メール/パスワード認証を扱っていたが、前提が崩れている
- 2025年以降の技術トレンド（Vibe Coding、Plan Mode、@supabase/ssr の推奨化）が反映されていない

### ゴール

- Chapter 5 を「UI 作成 + CRUD + Google 認証」を一気に扱うチャプターとして再設計する
- 「Vibe Coding」というコンセプトを軸に、非エンジニアが「自分にもできる」と実感できる構成にする
- Claude Code の最新機能（Plan Mode）を学習テーマに組み込む

---

## 設計

### チャプター概要

| 項目 | 内容 |
|------|------|
| タイトル | Chapter 5: Vibe Coding で TODO アプリを作る |
| 所要時間 | 約 3 時間 |
| ゴール | TODO アプリが一通り動く状態にする（UI + CRUD + Google ログイン） |
| 学ぶ Claude Code 機能 | Plan Mode、マルチファイル生成、統合的な指示（UI+DB 同時実装）、タスク分解 |

### 全体構成

| Step | 内容 | 所要時間 | 学ぶ Claude Code 機能 |
|------|------|---------|---------------------|
| Step 1 | Vibe Coding とは & Plan Mode で設計する | 20分 | Plan Mode（Shift+Tab × 2） |
| Step 2 | UI を一気に作る | 40分 | マルチファイル生成、自然言語指示 |
| Step 3 | CRUD を機能単位で繋ぐ | 60分 | 統合的な指示（UI+DB 同時実装） |
| Step 4 | Google ログインを組み込む | 40分 | タスク分解、@supabase/ssr |
| Step 5 | 通し確認 & コミット | 20分 | ビルドチェック、Git 操作 |

---

## Step 1: Vibe Coding とは & Plan Mode で設計する（20分）

### 概要

- 「Vibe Coding」の概念を紹介する（2025年 Collins Dictionary Word of the Year）
- 「AI に自然言語で指示するだけでアプリを作る」手法であり、まさにこのカリキュラムでやっていることだと伝える
- Claude Code の Plan Mode（Shift+Tab × 2）で、TODO アプリの全体設計を作成する
- 設計を確認・承認してから実装に進む

### 構成要素

- Vibe Coding の定義と日常のたとえ
- Plan Mode の操作方法（Shift+Tab × 2）
- Claude Code への指示例: 「TODO アプリの画面構成と必要なコンポーネントを設計して」
- 設計案の確認・承認の体験

### 体験ポイント

- Plan Mode は「建築の設計図を見てから家を建てる」のと同じ
- 設計が間違っていたら実装前に修正できるので、手戻りが少ない

---

## Step 2: UI を一気に作る（40分）

### 概要

Claude Code に自然言語で「TODO アプリの画面を作って」と指示し、以下のコンポーネントを段階的に生成する。この時点ではダミーデータで表示確認する。

**生成するコンポーネント**

- Header（ヘッダー: アプリタイトル + ログアウトボタン）
- AddTodoForm（追加フォーム: テキスト入力 + 追加ボタン）
- TodoItem（各 TODO アイテム: チェックボックス + テキスト + 削除ボタン）
- TodoList（TODO 一覧: TodoItem の集合）
- page.tsx（トップページ: 全コンポーネントを組み合わせ）

スタイリングには Tailwind CSS を使用する。

### Claude Code への指示例

```
TODO アプリの UI を作って。ヘッダー、TODO 追加フォーム、TODO リスト（各アイテムにチェックボックスと削除ボタン）を含めて。まずはダミーデータで表示して。Tailwind CSS を使って
```

### 生成されるファイル構成

```
src/
  components/
    Header.tsx
    AddTodoForm.tsx
    TodoItem.tsx
    TodoList.tsx
  app/
    page.tsx（更新）
```

### 確認ポイント

- 各コンポーネントファイルが作成されている
- ブラウザでダミーの TODO リストが表示される
- フォームの入力欄とボタンが見える
- ヘッダーにアプリタイトルが表示される

### 体験ポイント

- 「1行の指示で複数ファイルが同時に生成される」驚き
- デザイナーがいなくても、自然言語で UI の要望を伝えれば形になる

---

## Step 3: CRUD を機能単位で繋ぐ（60分）

### 概要

Step 2 で作ったダミー UI を、Supabase のデータベースに接続して「本物のデータ」で動くようにする。

### Phase A: 追加機能（Create）

**指示例**

```
AddTodoForm から新しい TODO を追加できるようにして。テキストを入力して送信すると、Supabase の todos テーブルに保存されて、フォームがリセットされるようにして
```

**確認**: フォーム送信 → Supabase Table Editor に行が追加される

### Phase B: 一覧表示（Read）

**指示例**

```
TodoList で Supabase から todos を取得して表示して。ページを開いたときに自動で読み込まれるようにして
```

**確認**: ページを開くと既存の todos が表示される

### Phase C: 完了切り替え（Update）

**指示例**

```
TodoItem のチェックボックスをクリックすると completed の状態が切り替わるようにして。Supabase の todos テーブルも更新されるようにして
```

**確認**: チェックボックス操作 → Supabase の completed カラムが更新される

### Phase D: 削除（Delete）

**指示例**

```
TodoItem の削除ボタンをクリックすると、その TODO が Supabase から削除されて一覧からも消えるようにして
```

**確認**: 削除ボタン → 一覧から消える + Supabase から行が消える

### ビルドチェック

`npm run build` でエラーがないことを確認する。

### 体験ポイント

- 「画面とデータベースを同時に実装して」という統合的な指示
- 機能単位（追加 → 表示 → 更新 → 削除）で動作確認しながら進める安心感

---

## Step 4: Google ログインを組み込む（40分）

### 概要

「誰でも TODO を操作できる」状態から「Google ログインした自分だけが操作できる」状態に変える。認証方式は Google OAuth のみに絞る。

### 前提の説明

- なぜ認証が必要か（「鍵のかかっていない家に住んでいる」状態の危険性）
- Google ログインを選ぶ理由（パスワード管理不要、非エンジニアにとって最も馴染みがある）

### Phase A: Claude Code に計画を立てさせる

**指示例**

```
Supabase Auth で Google ログインを実装したい。まず何をすべきか手順を教えて
```

Claude Code がタスクを分解して手順を提示する体験をする。

### Phase B: Supabase で Google Provider を有効化

- Supabase ダッシュボード → Authentication → Providers → Google を有効化
- Google Cloud Console での OAuth クライアント ID 取得手順（または Supabase のデフォルト設定を使用）
- クライアント ID・シークレットを Supabase に設定

### Phase C: @supabase/ssr のインストールと認証フロー実装

**パッケージのインストール**

```
npm install @supabase/ssr
```

> @supabase/ssr は旧 @supabase/auth-helpers の後継パッケージ（2025年1月に廃止されたため移行必須）。Cookie ベース認証が 2025年以降の推奨パターン。

**指示例**

```
Supabase Auth の Google ログインを実装して。@supabase/ssr を使って。未ログインの場合は /login にリダイレクトして
```

**生成されるファイル**

```
src/
  lib/supabase/
    client.ts（更新: ブラウザ用）
    server.ts（作成: サーバー用）
  middleware.ts（作成: 認証ガード）
  app/
    login/
      page.tsx（作成: Google ログインボタン）
    auth/callback/
      route.ts（作成: OAuth コールバック）
```

### Phase D: RLS の設定

**指示例**

```
todos テーブルに RLS を設定して。ログインユーザーが自分の TODO だけ操作できるようにして
```

- AddTodoForm で user_id を保存するよう更新する
- **セキュリティ警告**: 2025年に RLS 不備で 170+ アプリが情報漏洩した実際の事例を紹介し、重要性を伝える
- `auth.uid()` を使い、クライアントから送られた `user_id` を信用しないことの重要性を説明する

### 確認ポイント

- localhost:3000 にアクセスすると /login にリダイレクトされる
- 「Google でログイン」ボタンが表示される
- Google アカウントでログインすると TODO リスト画面に遷移する
- ヘッダーにログアウトボタンがある
- ログアウト → 再ログインで TODO が保持されている

---

## Step 5: 通し確認 & コミット（20分）

### テストシナリオ（8項目）

1. localhost:3000 → /login にリダイレクト
2. Google でログイン → TODO リスト画面に遷移
3. TODO を追加 → 一覧に表示 + Supabase に保存
4. TODO の一覧が表示される
5. TODO の完了を切り替え → 打ち消し線 + Supabase 更新
6. TODO を削除 → 一覧から消える + Supabase から削除
7. ログアウト → /login にリダイレクト
8. 再ログイン → TODO が保持されている

### ビルドチェック

`npm run build` がエラーなく完了することを確認する。

### Git コミット

- ブランチ確認（main でないこと）
- Conventional Commits 形式でコミット
- 例: `feat: implement todo app with CRUD and Google authentication`

---

## 現行 Chapter 5 からの変更点まとめ

| 項目 | 現行 | 再設計 |
|------|------|--------|
| UI 作成 | Chapter 3（削除済み）を前提 | Step 2 で一から作る |
| 冒頭コンセプト | CRUD の説明から開始 | Vibe Coding の概念紹介から開始 |
| Plan Mode | なし | Step 1 で体験（Shift+Tab × 2） |
| 認証方式 | メール/パスワード | Google OAuth のみ |
| ログイン画面 | メール/パスワード入力欄 + サインアップフォーム | 「Google でログイン」ボタン1つ |
| 認証パッケージ | @supabase/ssr（名前のみ） | Cookie ベース認証の推奨パターンを詳説 |
| セキュリティ教育 | RLS の概念説明のみ | 2025年の実際の漏洩事例で重要性を伝える |
| 学習テーマ | 統合的な指示、エージェント活用、タスク分解 | Vibe Coding、Plan Mode、統合的な指示、タスク分解 |

---

## 他チャプターへの影響

### 影響があるファイル

| ファイル | 変更内容 |
|---------|---------|
| `docs/curriculum/index.md` | Chapter 3 の行を削除、Chapter 5 のタイトルを更新 |
| `docs/curriculum/chapter-00-setup.md` | Figma 関連の事前準備を削除、Google アカウントの準備を追加 |
| `docs/curriculum/chapter-01-claude-code.md` | Figma MCP の設定を削除 |
| `docs/curriculum/chapter-06-git-workflow.md` | 事前確認のコンポーネントリストを更新 |
| `docs/curriculum/chapter-07-deploy.md` | 振り返り表から Chapter 3 を削除、Supabase の Google OAuth Redirect URL 設定を追加 |

### 影響の範囲

- 今回の作業スコープは Chapter 5 の設計ドキュメント作成まで
- 他チャプターの修正は別タスクとして実施する

---

## 成功基準

- 非エンジニアが「Vibe Coding って自分がやっていることだ」と実感できる
- Plan Mode を使って「作る前に設計を確認する」習慣が身につく
- Google ログインにより認証のハードルが最小限になる
- 3時間以内に TODO アプリが完成する
- RLS のセキュリティ重要性が実例で伝わる
