# Chapter 0: 環境準備（Mac）

> [!NOTE]
> **この資料について**: 事前準備および保守用の参照資料です。ハンズオン当日は、この資料を閲覧できる状態で参加してください。

**所要時間**: 約 1 時間
**ゴール**: Claude Code でコードが書ける状態にする
**対象者**: PC 操作に慣れた非エンジニア（ターミナルは少し使える程度）
**形式**: メンター付きハンズオン（座学ほぼなし）

---

## このチャプターでインストールするもの

| ツール | 読み方 | 役割 |
|--------|--------|------|
| Visual Studio Code | ビジュアル スタジオ コード | コードエディタ。ファイルの閲覧・編集を快適にするツール |
| Claude Code | クロード コード | 今回の主役。ターミナルから使う AI アシスタント |
| Git | ギット | ファイルの変更履歴を管理するツール |
| gh | ジーエイチ | GitHub をターミナルから操作するツール |
| nvm | エヌ・ブイ・エム | Node.js のバージョン管理ツール |
| Node.js | ノード ジェイエス | JavaScript の実行環境 |

> [!IMPORTANT]
> **ポイント**: Claude Code はネイティブアプリとして動作するため、Node.js がなくてもインストール・起動できます。Node.js は後から別途インストールします。

間違えても大丈夫です。途中でわからなくなったら、すぐメンターに声をかけてください。

---

## Step 1: Visual Studio Code のインストール

Visual Studio Code（VS Code）は、コードを書いたりファイルを閲覧・編集したりするためのエディタです。高機能なメモ帳のようなもので、Claude Code が生成したファイルをわかりやすく確認するのに役立ちます。

公式サイト <https://code.visualstudio.com/> にアクセスして、macOS 向けのインストーラーをダウンロードしてください。ダウンロードした `.zip` ファイルを展開し、`Visual Studio Code.app` をアプリケーションフォルダに移動したらインストール完了です。

**ターミナルから `code` コマンドを使えるようにする:**

VS Code を起動したら、`Cmd + Shift + P` でコマンドパレットを開き、`Shell Command: Install 'code' command in PATH` を選択して実行してください。これにより、ターミナルから `code` コマンドで VS Code を起動できるようになります。

**確認:**

```bash
# bash
code --version
```

バージョン番号が表示されれば OK です。

> [!NOTE]
> **Homebrew でもインストールできます**: Homebrew（次のステップでインストール）がすでに入っている場合は、`brew install --cask visual-studio-code` でインストールすることもできます。

- [ ] `code --version` でバージョン番号が表示された

---

## Step 2: Homebrew のインストール

Homebrew（ホームブリュー）は Mac 用のパッケージ管理ツールです。「Mac のアプリストア」のようなもので、コマンド一発でさまざまなソフトウェアをインストールできます。

ターミナルを開いてください。

> [!TIP]
> **ターミナルの開き方**: `Cmd + Space` を押して「ターミナル」と入力し、Enter キーを押します。

```bash
# bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

途中でパスワードを求められたら Mac のログインパスワードを入力してください（入力中は文字が表示されません）。

**確認:**

```bash
# bash
brew --version
```

`Homebrew 4.x.x` のようなバージョン番号が表示されれば OK です。

> [!NOTE]
> **Apple Silicon Mac（M1/M2/M3/M4）の場合**: インストール後に以下を実行してください。
>
> ```bash
> # bash
> echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
> eval "$(/opt/homebrew/bin/brew shellenv)"
> ```

- [ ] `brew --version` でバージョン番号が表示された

---

## Step 3: Claude Code のインストール・認証

以下を実行するだけでインストールが完了します。

```bash
# bash
curl -fsSL https://claude.ai/install.sh | bash
```

インストール後、ブラウザが自動で開きます。Claude.ai のアカウントでログインしてください。

> [!NOTE]
> **Claude.ai のアカウントをお持ちでない場合**: [claude.ai](https://claude.ai) にアクセスしてサインアップしてください。Claude Code を使うには **Pro プラン以上**が必要です。

**確認:**

```bash
# bash
claude --version
```

バージョン番号が表示されれば OK です。

- [ ] `claude --version` でバージョン番号が表示された

---

## Step 4: 作業用ディレクトリの作成

Claude Code はホームディレクトリ（`~`）ではなく、専用の作業用フォルダで実行します。

```bash
# bash
mkdir ~/works
```

> [!NOTE]
> **`mkdir` とは?** 「make directory」の略で、新しいフォルダを作成するコマンドです。`~/works` は「ホームフォルダの中に works フォルダを作る」という意味です。

- [ ] `~/works` フォルダを作成した

---

## Step 5: git, gh, nvm のインストール

Homebrew を使って一括でインストールします。

```bash
# bash
brew install git gh nvm
```

nvm をターミナルで使えるようにするため、以下を実行してください。これは「ターミナルを開くたびに nvm を自動で読み込む」ための設定です。

```bash
# bash
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zprofile
echo '[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh"' >> ~/.zprofile
source ~/.zprofile
```

**確認:**

```bash
# bash
git --version
gh --version
nvm --version
```

それぞれバージョン番号が表示されれば OK です。

- [ ] `git --version` でバージョンが表示された
- [ ] `gh --version` でバージョンが表示された
- [ ] `nvm --version` でバージョンが表示された

**Git のグローバル設定:**

インストール後、コミット時に使われる名前とメールアドレスを設定します。

```bash
# bash
git config --global user.name "あなたの名前"
git config --global user.email "your@email.com"
```

> [!NOTE]
> **なぜ必要？** Git は変更を記録するとき「誰が変更したか」を一緒に保存します。この設定がないと、コミット（変更の保存）ができない場合があります。

**確認:**

```bash
# bash
git config --global user.name
git config --global user.email
```

設定した名前とメールアドレスが表示されれば OK です。

- [ ] Git のグローバル設定（user.name / user.email）を完了した

---

## Step 6: Node.js のインストール

nvm を使って Node.js をインストールします。

```bash
# bash
nvm install --lts
nvm use --lts
```

> [!NOTE]
> **`--lts` とは?** 「Long Term Support（長期サポート版）」の略で、安定した推奨バージョンを自動で選んでインストールしてくれます。

**確認:**

```bash
# bash
node --version
npm --version
```

バージョン番号が表示されれば OK です。

- [ ] `node --version` でバージョン番号が表示された

---

## Step 7: GitHub CLI（gh）の認証

```bash
# bash
gh auth login
```

ブラウザが自動で開くので、GitHub アカウントでログインしてください。

> [!NOTE]
> **GitHub アカウントをお持ちでない場合**: [github.com](https://github.com) でアカウントを作成してください（無料）。

**確認:**

```bash
# bash
gh auth status
```

`Logged in to github.com` のような表示が出れば OK です。

- [ ] `gh auth status` で認証済みと表示された

---

## Claude Code の初回起動

まず、作業用ディレクトリに移動してから起動します。**ホームディレクトリ（`~`）で直接起動しないように注意してください。**

```bash
# bash
cd ~/works
claude
```

> [!NOTE]
> **なぜプロジェクトディレクトリで起動するの?** Claude Code は起動したフォルダを「作業場所」として認識します。ホームディレクトリで起動してしまうと、すべてのファイルが見える状態になり、意図しない場所にファイルが作られることがあります。

`>` プロンプトが表示されたら起動成功です。試しに話しかけてみてください。

```plaintext
# claude
こんにちは！
```

Claude から返答が来れば完璧です。終了するには `/exit` と入力するか `Ctrl + C` を押してください。

- [ ] `claude` コマンドで Claude Code が起動した
- [ ] Claude に話しかけて返答が来た

---

## 完了チェックリスト

Chapter 0 が完了したら、以下がすべてチェックできているはずです。

- [ ] `code --version` でバージョン番号が表示される
- [ ] `claude --version` でバージョン番号が表示される
- [ ] `claude` コマンドで起動して会話できる
- [ ] `git --version` でバージョン番号が表示される
- [ ] `gh auth status` で認証済みと表示される
- [ ] `node --version` でバージョン番号が表示される

---

## このチャプターのまとめ

このチャプターでは、Claude Code を使うための環境を整えました。

- **Visual Studio Code** でコードの閲覧・編集ができるようになりました
- **Claude Code** をネイティブアプリとしてインストール・認証しました
- **Git（ギット）** で変更履歴の管理ができるようになりました
- **gh** で GitHub 操作がターミナルからできるようになりました
- **nvm + Node.js** で JavaScript の実行環境を整えました
- 作業用ディレクトリ `~/works` を用意しました

次の Chapter 1 では、Next.js アプリのスキャフォールドを実行し、GitHub にリポジトリを作成して `/init` コマンドで CLAUDE.md を生成します。

すべてチェックできたら **Chapter 1** に進んでください。お疲れさまでした。

---

## 自己学習リソース（インストール後に読もう）

インストール後や当日前日に視聴しておくと、ハンズオンがスムーズに進みます。
「ターミナルって何？」「Git って何？」という疑問を事前に解消しておきましょう。

### ターミナル・Linux コマンド

ハンズオンでは黒い画面（ターミナル）にコマンドを打ち込む操作が頻出します。
事前に「コマンドとはなにか」のイメージをつかんでおくと理解が早くなります。

| 動画 | ポイント |
|---|---|
| [Linux コマンドとターミナルと仲良くなる勉強会（YouTube）](https://www.youtube.com/watch?v=M5JCfGttqno) | CTO・VPoE によるハンズオン勉強会の録画。「ターミナルとは何か」から基本コマンドまで約 30 分で解説 |

> [!TIP]
> **最低限知っておくとよいコマンド**: `cd`（移動）、`ls`（一覧）、`mkdir`（フォルダ作成）、`pwd`（現在地確認）

### Git / GitHub

聞いたことも、なんとなくの概念も知ってると思いますが、改めてしっかり学習しましょう。

| リソース | ポイント |
|---|---|
| [Git・GitHub 入門（YouTube）](https://youtu.be/LDOR5HfI_sQ?si=7Fk-xOXzeokFn4d2) | Git と GitHub の基礎を動画でしっかり学べる |
| [初心者必読！GitHubの使い方を徹底解説【完全網羅版】](https://www.creativevillage.ne.jp/category/topcreators/web-creator/web-programmer/128504/) | リポジトリ作成からブランチ・マージまで、図解つきで網羅した記事 |

> [!TIP]
> **確認ポイント**: リポジトリ、コミット、プッシュ の 3 つの言葉の意味がわかれば OK

---

## 事前準備リファレンス

> [!NOTE]
> このセクションには、後のチャプターで必要になるツールやアカウントをまとめています。
> 各チャプターに進む前に、該当する項目を**必ず**準備してください。

---

### Supabase アカウント + supabase-js（Chapter 3 で使用）

Chapter 3 で Supabase（データベースと認証を提供するクラウドサービス）を使います。

1. [Supabase](https://supabase.com/) にアクセスしてアカウントを作成（GitHub 連携が簡単）
2. パッケージのインストール（プロジェクトディレクトリで実行）:

```bash
# bash
npm install @supabase/supabase-js
```

- [ ] Supabase アカウントを作成した
- [ ] `@supabase/supabase-js` をインストールした

---

### Vercel アカウント + Vercel CLI（Chapter 6 で使用）

Chapter 6 でアプリをインターネットに公開（デプロイ）します。

1. [Vercel](https://vercel.com/) にアクセスしてアカウントを作成（GitHub 連携が簡単）
2. Vercel CLI（ターミナルから Vercel を操作するツール）をインストール:

```bash
# bash
npm install -g vercel
```

3. Vercel にログイン:

```bash
# bash
vercel login
```

ブラウザが開くので、作成したアカウントでログインしてください。

- [ ] Vercel アカウントを作成した
- [ ] Vercel CLI をインストールした
- [ ] `vercel login` でログインした

---

*最終更新: 2026-03-10*

---

[← プロローグ: 今日から私は](chapter-prologue.md) | [Chapter 1: ターミナル・Bash 入門 →](chapter-01-bash.md)
