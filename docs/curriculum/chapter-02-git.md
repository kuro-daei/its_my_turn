# Chapter 2: Git・GitHub 入門

> [!NOTE]
> **この章について**: 座学70% ・ ハンズオン30%の構成です。「Git って何？なぜ使うの？」という疑問を解消してから、実際の操作を体験します。

**所要時間**: 約 1 時間
**ゴール**: Git でファイルの変更を記録し、GitHub にプッシュできる状態にする
**対象者**: PC 操作に慣れた非エンジニア（Git を使ったことがない方）
**形式**: 座学 → ハンズオン

---

## Git とは何か

### 「保存」ではなく「記録」

Word や Excel でファイルを「保存」すると、上書きされて前の状態はなくなりますよね。Git は違います。Git は変更のたびに **スナップショット（記録）** を積み重ねていくツールです。

- 「保存」= 上書き（前の状態は消える）
- 「コミット（Git の記録）」= 変更履歴を積み重ねる（いつでも過去に戻れる）

### たとえ話

**ゲームのセーブデータ**で考えてみましょう。

- ゲームを進めながら「ここで一回セーブしておこう」とセーブポイントを作りますよね
- ボスに負けたり迷ったりしたら、セーブポイントまで戻れます
- Git の「コミット」は、このセーブポイントを作る操作です

もうひとつのたとえとして **Google ドキュメントの変更履歴** があります。

- Google ドキュメントは「誰がいつ何を変更したか」が履歴として残ります
- 古い状態に巻き戻すこともできます
- Git はこれをプログラムのソースコード向けに高度化したものです

### Git がないとどうなるか

Git を使わずにファイルを管理すると、こんな地獄が待っています。

```
report_v1.txt
report_v2.txt
report_v2_修正.txt
report_v2_修正_final.txt
report_v2_修正_final_本当のfinal.txt
```

どれが最新かわからなくなり、チームで作業すると誰かの変更が誰かの変更を上書きしてしまう事故も起きます。Git はこういった問題を解決するために生まれました。

---

## GitHub とは何か

**Git** がローカル（自分の PC）での変更管理ツールなら、**GitHub** はその記録をインターネット上に保存・共有するサービスです。

> GitHub = Git のリモート（遠隔）保存場所 ＋ チーム共有の仕組み

たとえ話でいうと、

- **Git** = 手元のメモ帳（ローカルの変更記録）
- **GitHub** = Dropbox のような共有クラウドストレージ（ただし開発者向けに特化）

GitHub にコードをアップロードしておけば、

- チームメンバーと最新のコードを共有できる
- PC が壊れてもコードが消えない
- 誰がいつどんな変更をしたか一目でわかる

---

## 重要な概念

Git・GitHub を使うときに出てくる用語をまとめました。最初は「なんとなくこういう意味か」でOKです。

| 用語 | 読み方 | たとえ話 |
|---|---|---|
| リポジトリ（レポ） | リポジトリ | プロジェクト全体の記録箱。Git の管理対象フォルダ |
| コミット | コミット | ある時点のスナップショット（ゲームのセーブポイント） |
| ステージング（インデックス） | ステージング | コミット前の「次に記録する変更」を選ぶ準備エリア |
| ブランチ | ブランチ | 作業の分岐。本流に影響を与えずに試し書きできるコピー |
| リモート | リモート | GitHub 上のリポジトリ（遠隔地の保存場所） |
| プッシュ | プッシュ | ローカルの記録を GitHub（リモート）にアップロード |
| プル | プル | GitHub（リモート）の最新状態をローカルに反映 |

---

## Git の基本的な流れ

実際の作業はこのような流れになります。

```
1. ファイルを編集する（作業）
        ↓
2. git add（ステージング）
   ─ 「次のコミットに含める変更」を選ぶ
        ↓
3. git commit（コミット）
   ─ 選んだ変更をスナップショットとして記録する
        ↓
4. git push（プッシュ）
   ─ ローカルの記録を GitHub にアップロードする
```

この「作業 → add → commit → push」の4ステップが基本の流れです。

> [!NOTE]
> **Claude Code と Git の関係**: Claude Code は多くの Git 操作を自動でやってくれます。「コミットして」と伝えるだけで `git add` → `git commit` まで実行してくれます。ただし概念を理解しておくと、エラーが起きたときに対処しやすくなります。

---

## ハンズオン：はじめての Git 操作

Chapter 1 で作成した `bash-practice` フォルダを使います。

### Step 1: Git の設定を確認する

- [ ] 自分の名前が設定されているか確認する

```bash
git config --global user.name
```

```output
Taro Yamada
```

- [ ] メールアドレスが設定されているか確認する

```bash
git config --global user.email
```

```output
taro@example.com
```

何も表示されない場合は以下のように設定します（名前とメールアドレスは自分のものに変えてください）。

```bash
git config --global user.name "Taro Yamada"
git config --global user.email "taro@example.com"
```

---

### Step 2: リポジトリを初期化する

- [ ] `bash-practice` フォルダに移動する

```bash
cd ~/works/bash-practice
```

- [ ] Git リポジトリとして初期化する

```bash
git init
```

```output
Initialized empty Git repository in /Users/yourname/works/bash-practice/.git/
```

`git init` を実行すると、フォルダの中に `.git` という隠しフォルダが作られます。これが Git の記録ファイル群です。

---

### Step 3: ファイルを作成する

- [ ] `hello.txt` というファイルを作り、文字を書き込む

```bash
echo "Hello Git" > hello.txt
```

---

### Step 4: 状態を確認する

- [ ] 現在の Git の状態を確認する

```bash
git status
```

```output
On branch main

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	hello.txt

nothing added to commit but untracked files present (use "git add" to track)
```

`Untracked files`（追跡されていないファイル）として `hello.txt` が表示されます。まだ Git に記録されていない状態です。

---

### Step 5: ステージングに追加する

- [ ] `hello.txt` をコミット対象として選ぶ（ステージングに追加する）

```bash
git add hello.txt
```

- [ ] 状態を再確認する

```bash
git status
```

```output
On branch main

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
	new file:   hello.txt
```

`Changes to be committed`（コミット予定の変更）に移動しました。

---

### Step 6: コミットする

- [ ] 変更をコミットとして記録する

```bash
git commit -m "feat: はじめてのコミット"
```

```output
[main (root-commit) a1b2c3d] feat: はじめてのコミット
 1 file changed, 1 insertion(+)
 create mode 100644 hello.txt
```

> [!TIP]
> **コミットメッセージは「何をしたか」を短く書く**: `git commit -m "..."` の `"..."` の部分がコミットメッセージです。あとで履歴を見たときにわかるよう、何をしたかを簡潔に書きましょう。このカリキュラムでは `feat:（機能追加）` `fix:（バグ修正）` `docs:（ドキュメント）` のような接頭辞をつける形式を使います。

---

### Step 7: 履歴を確認する

- [ ] コミット履歴を一覧表示する

```bash
git log --oneline
```

```output
a1b2c3d (HEAD -> main) feat: はじめてのコミット
```

コミットが1件記録されています。

---

### Step 8: ファイルを変更して差分を確認する

- [ ] `hello.txt` に1行追加する

```bash
echo "second line" >> hello.txt
```

- [ ] 変更前後の差分を確認する

```bash
git diff
```

```output
diff --git a/hello.txt b/hello.txt
index 8ab686e..5e2e5a0 100644
--- a/hello.txt
+++ b/hello.txt
@@ -1 +1,2 @@
 Hello Git
+second line
```

`+` が付いている行が新しく追加された行です。

---

### Step 9: 変更をコミットする

- [ ] 変更をステージングに追加してコミットする

```bash
git add hello.txt
git commit -m "docs: hello.txt に2行目を追加"
```

- [ ] 履歴が2件になったことを確認する

```bash
git log --oneline
```

```output
b2c3d4e (HEAD -> main) docs: hello.txt に2行目を追加
a1b2c3d feat: はじめてのコミット
```

2つのセーブポイント（コミット）が積み重なりました。お疲れさまでした。

---

## GitHub にプッシュするには（説明のみ）

ローカルに積み重ねたコミットを GitHub に公開する操作が「プッシュ」です。

大まかな流れは以下の通りです。

```bash
# GitHub にリポジトリを作成する（gh コマンド）
gh repo create my-project --public

# リモートとして GitHub を登録する
git remote add origin https://github.com/yourname/my-project.git

# GitHub にプッシュする
git push -u origin main
```

実際のプッシュ操作は **Chapter 3: プロジェクト初期化** で行います。そちらで本物のプロジェクトを GitHub にアップロードする体験をしましょう。

---

## まとめ

Git はコードの変更履歴を管理するタイムマシンです。「作業 → add → commit → push」という基本の流れを覚えておけば、最初は十分です。

コマンドをすべて覚える必要はありません。Claude Code が多くの操作を自動でやってくれます。ただし「コミットって何？」「ステージングって何の準備？」という概念を理解しておくと、Claude Code に的確な指示を出せるようになります。

### 補足資料

Git の用語や仕組みをさらに詳しく知りたい場合は補足資料を参照してください。

[Git 仕様ガイド](supplement-02-git.md)

---

[← Chapter 1: ターミナル・Bash 入門](chapter-01-bash.md) | [Chapter 3: プロジェクト初期化 →](chapter-03-project-init.md)
