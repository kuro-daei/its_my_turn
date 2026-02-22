# Chapter 0: 環境準備

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
| uv | ユーブイ | Python のバージョン・パッケージ管理ツール |
| Python | パイソン | Python の実行環境 |

> **ポイント**: Claude Code はネイティブアプリとして動作するため、Node.js がなくてもインストール・起動できます。Node.js は後から別途インストールします。

間違えても大丈夫です。途中でわからなくなったら、すぐメンターに声をかけてください。

---

## Mac の場合

### Step 1: Visual Studio Code のインストール

Visual Studio Code（VS Code）は、コードを書いたりファイルを閲覧・編集したりするためのエディタです。高機能なメモ帳のようなもので、Claude Code が生成したファイルをわかりやすく確認するのに役立ちます。

公式サイト <https://code.visualstudio.com/> にアクセスして、macOS 向けのインストーラーをダウンロードしてください。ダウンロードした `.zip` ファイルを展開し、`Visual Studio Code.app` をアプリケーションフォルダに移動したらインストール完了です。

**ターミナルから `code` コマンドを使えるようにする:**

VS Code を起動したら、`Cmd + Shift + P` でコマンドパレットを開き、`Shell Command: Install 'code' command in PATH` を選択して実行してください。これにより、ターミナルから `code` コマンドで VS Code を起動できるようになります。

**確認:**

```bash
code --version
```

バージョン番号が表示されれば OK です。

> **Homebrew でもインストールできます**: Homebrew（次のステップでインストール）がすでに入っている場合は、`brew install --cask visual-studio-code` でインストールすることもできます。

- [ ] `code --version` でバージョン番号が表示された

---

### Step 2: Homebrew のインストール

Homebrew（ホームブリュー）は Mac 用のパッケージ管理ツールです。「Mac のアプリストア」のようなもので、コマンド一発でさまざまなソフトウェアをインストールできます。

ターミナルを開いてください。

> **ターミナルの開き方**: `Cmd + Space` を押して「ターミナル」と入力し、Enter キーを押します。

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

途中でパスワードを求められたら Mac のログインパスワードを入力してください（入力中は文字が表示されません）。

**確認:**

```bash
brew --version
```

`Homebrew 4.x.x` のようなバージョン番号が表示されれば OK です。

> **Apple Silicon Mac（M1/M2/M3/M4）の場合**: インストール後に以下を実行してください。
>
> ```bash
> echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
> eval "$(/opt/homebrew/bin/brew shellenv)"
> ```

**うまくいかない場合は**

- `curl: command not found` と表示された場合: ターミナルを一度閉じて開き直してから再試行してください。
- わからない場合はメンターに声をかけてください。

- [ ] `brew --version` でバージョン番号が表示された

---

### Step 3: Claude Code のインストール・認証

以下を実行するだけでインストールが完了します。

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

インストール後、ブラウザが自動で開きます。Claude.ai のアカウントでログインしてください。

> **Claude.ai のアカウントをお持ちでない場合**: [claude.ai](https://claude.ai) にアクセスしてサインアップしてください。Claude Code を使うには **Pro プラン以上**が必要です。

**確認:**

```bash
claude --version
```

バージョン番号が表示されれば OK です。

**うまくいかない場合は**

- ブラウザが開かない場合: ターミナルに表示された URL を手動でブラウザに貼り付けてください。
- メンターに声をかけてください。

- [ ] `claude --version` でバージョン番号が表示された

---

### Step 4: 作業用ディレクトリの作成

Claude Code はホームディレクトリ（`~`）ではなく、専用の作業用フォルダで実行します。

```bash
mkdir ~/projects
```

> **`mkdir` とは?** 「make directory」の略で、新しいフォルダを作成するコマンドです。`~/projects` は「ホームフォルダの中に projects フォルダを作る」という意味です。

- [ ] `~/projects` フォルダを作成した

---

### Step 5: git, gh, nvm, uv のインストール

Homebrew を使って一括でインストールします。

```bash
brew install git gh nvm uv
```

nvm をターミナルで使えるようにするため、以下を実行してください。これは「ターミナルを開くたびに nvm を自動で読み込む」ための設定です。

```bash
echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.zprofile
echo '[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh"' >> ~/.zprofile
source ~/.zprofile
```

**確認:**

```bash
git --version
gh --version
nvm --version
uv --version
```

それぞれバージョン番号が表示されれば OK です。

- [ ] `git --version` でバージョンが表示された
- [ ] `gh --version` でバージョンが表示された
- [ ] `nvm --version` でバージョンが表示された
- [ ] `uv --version` でバージョンが表示された

---

### Step 6: Node.js のインストール

nvm を使って Node.js をインストールします。

```bash
nvm install --lts
nvm use --lts
```

> **`--lts` とは?** 「Long Term Support（長期サポート版）」の略で、安定した推奨バージョンを自動で選んでインストールしてくれます。

**確認:**

```bash
node --version
npm --version
```

バージョン番号が表示されれば OK です。

- [ ] `node --version` でバージョン番号が表示された

---

### Step 7: Python のインストール

uv を使って Python をインストールします。

```bash
uv python install
```

**確認:**

```bash
uv python list
```

Python のバージョンが表示されれば OK です。

- [ ] Python がインストールされた

---

### Step 8: GitHub CLI（gh）の認証

```bash
gh auth login
```

ブラウザが自動で開くので、GitHub アカウントでログインしてください。

> **GitHub アカウントをお持ちでない場合**: [github.com](https://github.com) でアカウントを作成してください（無料）。

**確認:**

```bash
gh auth status
```

`Logged in to github.com` のような表示が出れば OK です。

- [ ] `gh auth status` で認証済みと表示された

---

## Windows の場合（WSL + Ubuntu 24）

Windows では **WSL（Windows Subsystem for Linux）** 上の Ubuntu 24 で作業します。

> **WSL（ダブリュー・エス・エル）とは?** Windows の中で Linux（リナックス）を動かす仕組みです。Web 開発の多くのツールは Linux 向けに作られているため、Mac と同じコマンドが使えるようになります。

### Step 1: Visual Studio Code のインストール

Visual Studio Code（VS Code）は、コードを書いたりファイルを閲覧・編集したりするためのエディタです。高機能なメモ帳のようなもので、Claude Code が生成したファイルをわかりやすく確認するのに役立ちます。

公式サイト <https://code.visualstudio.com/> にアクセスして、Windows 向けのインストーラーをダウンロードしてください。ダウンロードした `.exe` ファイルを実行し、画面の指示に従ってインストールしてください。

または、PowerShell で以下を実行してもインストールできます。

```powershell
winget install Microsoft.VisualStudioCode
```

**WSL 拡張機能のインストール:**

後の手順で WSL 内のファイルを VS Code で開くために、「WSL」拡張機能を入れておきます。

1. VS Code を起動する
2. 左サイドバーの拡張機能アイコン（四角が4つ並んだアイコン）をクリック
3. 検索欄に「WSL」と入力
4. 「WSL」（Microsoft 製）が表示されたら「インストール」をクリック

**確認:**

PowerShell で以下を実行してください。

```powershell
code --version
```

バージョン番号が表示されれば OK です。

- [ ] `code --version` でバージョン番号が表示された

---

### Step 2: Windows Terminal のインストール

PowerShell を**管理者として実行**して以下を入力してください。

> **管理者として実行するには**: スタートメニューで「PowerShell」を検索 → 右クリック → 「管理者として実行」

```powershell
winget install Microsoft.WindowsTerminal
```

> **すでにインストール済みの場合**: 「既にインストールされています」と表示されることがあります。その場合はそのまま次に進んでください。

- [ ] Windows Terminal をインストールした

---

### Step 3: WSL + Ubuntu 24 のインストール

PowerShell（管理者として実行）で以下を実行してください。

```powershell
wsl --install -d Ubuntu-24.04
```

インストール後、**PC を再起動** してください。

再起動後、Ubuntu が自動起動してユーザー名とパスワードの設定を求められます。

> **注意**: ここで設定するユーザー名・パスワードは WSL 内の Linux 専用です。Windows のアカウントとは別です。パスワードは入力中に文字が表示されません（正常です）。

**確認:**

Windows Terminal を開いて Ubuntu タブを開き:

```bash
uname -a
```

`Linux ...` から始まる文字列が表示されれば OK です。

**うまくいかない場合は**

- Windows Update で最新版にアップデートしてから再試行してください。
- BIOS で仮想化が無効になっている場合は、メンターに確認してください。

- [ ] WSL で Ubuntu が起動できた

> **重要**: 以降の手順はすべて **WSL の Ubuntu ターミナル内**で実行してください。

---

### Step 4: パッケージの更新

Ubuntu ターミナルで最初に以下を実行してください。

```bash
sudo apt update && sudo apt upgrade -y
```

> **`sudo` とは?** 「管理者として実行する」という意味です。パスワードを求められたら WSL セットアップ時に設定したパスワードを入力してください。

---

### Step 5: Claude Code のインストール・認証

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

インストール後、ターミナルに URL と認証コードが表示されます。

1. 表示された URL を **Windows のブラウザ**で開く
2. Claude.ai のアカウントでログイン
3. 表示された認証コードをターミナルに貼り付けて Enter

> **Claude.ai のアカウントをお持ちでない場合**: [claude.ai](https://claude.ai) でサインアップしてください（Pro プラン以上が必要）。

**確認:**

```bash
claude --version
```

バージョン番号が表示されれば OK です。

- [ ] `claude --version` でバージョン番号が表示された

---

### Step 6: 作業用ディレクトリの作成

```bash
mkdir ~/projects
```

> **`mkdir` とは?** 「make directory」の略で、新しいフォルダを作成するコマンドです。`~/projects` は「ホームフォルダの中に projects フォルダを作る」という意味です。

- [ ] `~/projects` フォルダを作成した

---

### Step 7: git, gh のインストール

**git:**

```bash
sudo apt install -y git
```

**gh（GitHub CLI）:**

```bash
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update && sudo apt install -y gh
```

**確認:**

```bash
git --version
gh --version
```

- [ ] `git --version` でバージョンが表示された
- [ ] `gh --version` でバージョンが表示された

---

### Step 8: nvm のインストール

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc
```

**確認:**

```bash
nvm --version
```

- [ ] `nvm --version` でバージョンが表示された

---

### Step 9: Node.js のインストール

```bash
nvm install --lts
nvm use --lts
```

**確認:**

```bash
node --version
npm --version
```

- [ ] `node --version` でバージョン番号が表示された

---

### Step 10: uv のインストール

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
source ~/.bashrc
```

**確認:**

```bash
uv --version
```

- [ ] `uv --version` でバージョンが表示された

---

### Step 11: Python のインストール

```bash
uv python install
```

**確認:**

```bash
uv python list
```

- [ ] Python がインストールされた

---

### Step 12: gh の認証

```bash
gh auth login
```

ターミナルに URL と認証コードが表示されます。URL を Windows のブラウザで開いて GitHub アカウントでログインし、表示されたコードをターミナルに貼り付けてください。

**確認:**

```bash
gh auth status
```

- [ ] `gh auth status` で認証済みと表示された

---

## Claude Code の初回起動

Claude Code を起動します。

```bash
claude
```

`>` プロンプトが表示されたら起動成功です。試しに話しかけてみてください。

```plaintext
こんにちは！
```

Claude から返答が来れば完璧です。終了するには `/exit` と入力するか `Ctrl + C` を押してください。

**うまくいかない場合は**

- 認証エラーが表示された場合: `claude --version` でインストールを確認してください。
- それでも解決しない場合は、メンターに声をかけてください。

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
- [ ] `uv --version` でバージョン番号が表示される
- [ ] Python がインストールされている

---

## このチャプターのまとめ

このチャプターでは、Claude Code を使うための環境を整えました。

- **Visual Studio Code** でコードの閲覧・編集ができるようになりました
- **Claude Code** をネイティブアプリとしてインストール・認証しました
- **Git（ギット）** で変更履歴の管理ができるようになりました
- **gh** で GitHub 操作がターミナルからできるようになりました
- **nvm + Node.js** で JavaScript の実行環境を整えました
- **uv + Python** で Python の実行環境を整えました
- 作業用ディレクトリ `~/projects` を用意しました

次の Chapter 1 では、Next.js アプリのスキャフォールドを実行し、GitHub にリポジトリを作成して `/init` コマンドで CLAUDE.md を生成します。

すべてチェックできたら **Chapter 1** に進んでください。お疲れさまでした。

---

## 事前準備リファレンス

> このセクションには、後のチャプターで必要になるツールやアカウントをまとめています。
> 各チャプターに進む前に、該当する項目を**必ず**準備してください。

---

### Figma アカウント + Personal Access Token（Chapter 2 で使用）

Chapter 2（MCP サーバー設定）で Figma を使います。事前に準備しておきましょう。

1. [Figma](https://www.figma.com/) にアクセスしてアカウントを作成（無料プランで OK）
2. Personal Access Token を発行:
   - Figma にログイン → 左上のアイコン → **Settings**
   - **Personal access tokens** セクションで **Generate new token** をクリック
   - トークン名を入力（例: `claude-code`）→ **Generate token**
   - 表示されたトークン（`figd_` で始まる文字列）をコピーして安全な場所に保存

> **注意:** トークンは一度しか表示されません。忘れた場合は新しく発行してください。

- [ ] Figma アカウントを作成した
- [ ] Personal Access Token を発行して保存した

---

### Supabase アカウント + supabase-js（Chapter 3 で使用）

Chapter 3 で Supabase（データベースと認証を提供するクラウドサービス）を使います。

1. [Supabase](https://supabase.com/) にアクセスしてアカウントを作成（GitHub 連携が簡単）
2. パッケージのインストール（プロジェクトディレクトリで実行）:

```bash
npm install @supabase/supabase-js
```

3. Chapter 3 で Supabase プロジェクトを作成した後、`.env.local` に接続情報を設定します:

```text
NEXT_PUBLIC_SUPABASE_URL=your-project-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```

> **注意:** `.env.local` は `.gitignore` に含まれていることを確認してください。秘密の情報が外部に漏れるのを防ぎます。

- [ ] Supabase アカウントを作成した
- [ ] `@supabase/supabase-js` をインストールした

---

### 認証パッケージ（Chapter 4 で使用）

Chapter 4 で SPA ベースのログイン認証を実装します。以下のパッケージを追加インストールしてください。

```bash
npm install @supabase/ssr
```

`@supabase/ssr` は、Supabase の認証機能を Next.js で使うためのヘルパーパッケージです。

- [ ] `@supabase/ssr` をインストールした

---

### Vercel アカウント + Vercel CLI（Chapter 6 で使用）

Chapter 6 でアプリをインターネットに公開（デプロイ）します。

1. [Vercel](https://vercel.com/) にアクセスしてアカウントを作成（GitHub 連携が簡単）
2. Vercel CLI（ターミナルから Vercel を操作するツール）をインストール:

```bash
npm install -g vercel
```

3. Vercel にログイン:

```bash
vercel login
```

ブラウザが開くので、作成したアカウントでログインしてください。

- [ ] Vercel アカウントを作成した
- [ ] Vercel CLI をインストールした
- [ ] `vercel login` でログインした

---

*最終更新: 2026-02-21*
