# Module 0: 環境準備

**所要時間**: 約 1 時間
**ゴール**: Claude Code でコードが書ける状態にする
**対象者**: PC 操作に慣れた非エンジニア（ターミナルは少し使える程度）
**形式**: メンター付きハンズオン（座学ほぼなし）

---

## このモジュールで学ぶこと

- Node.js をインストールする
- Git をインストールする
- ターミナル環境を整える
- Claude Code をインストールする
- API Key を取得して設定する

全部終わったら、`claude` コマンドが動いて Claude と会話できる状態になります。

---

**「何をインストールするの？」という疑問に先に答えます**

これからインストールするものは全部で 4 つです。料理にたとえると「調理道具を揃える」段階です。

- **Node.js**: Claude Code を動かすための「エンジン」。車のエンジンのようなもので、これがないと Claude Code は動きません。
- **Git（ジット）**: ファイルの変更履歴を管理するツール。Word の「変更履歴」機能の超強力版です。「3日前の状態に戻したい」「この変更は誰がしたの？」が即座にわかります。
- **Claude Code**: 今回の主役。ターミナル（後述）から使える AI アシスタントで、ファイルを読んだり書いたり、コマンドを実行したりできます。
- **API Key（エーピーアイ キー）**: Claude Code を動かすための「鍵」。Claude のサービスを使うための認証情報です。

間違えても大丈夫です。途中でわからなくなったら、すぐメンターに声をかけてください。

---

## Step 1: Node.js のインストール

Claude Code は Node.js（ノード・ジェーエス）という実行環境の上で動きます。まずこれをインストールします。

> **Node.js とは?** JavaScript というプログラミング言語をパソコン上で動かすための仕組みです。もともと JavaScript はウェブブラウザの中でしか動きませんでしたが、Node.js のおかげでパソコン上でも動かせるようになりました。

### Mac の場合

#### 1-1. Homebrew のインストール（入っていない場合）

Homebrew（ホームブリュー）は Mac 用のパッケージ管理ツールです。「Mac のアプリストア」のようなもので、コマンド一発でさまざまなソフトウェアをインストールできます。

ターミナル（コンピュータに文字で指示を出す画面）を開いて以下を実行してください。

> **ターミナルの開き方**: キーボードの `Cmd + Space` を押して「ターミナル」と入力し、Enter キーを押します。

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

途中でパスワードを求められたら、Mac のログインパスワードを入力してください。入力中は文字が表示されませんが正常です（セキュリティのため非表示になっています）。

**確認ポイント**

```bash
brew --version
```

`Homebrew 4.x.x` のようなバージョン番号が表示されれば OK です。

[screenshot: ターミナルで brew --version を実行して Homebrew のバージョンが表示されている様子]

> **注意:** Apple Silicon Mac（M1/M2/M3/M4 チップ）の場合、インストール後に以下のコマンドを実行する必要があります。インストール完了時にターミナルに表示される指示に従ってください。
>
> ```bash
> echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
> eval "$(/opt/homebrew/bin/brew shellenv)"
> ```

**うまくいかない場合は**
- `curl: command not found` と表示された場合: ターミナルを一度閉じて開き直してから再試行してください。
- インストールが途中で止まった場合: ネットワーク環境を確認し、再度同じコマンドを実行してください（同じコマンドを何度実行しても問題ありません）。
- わからない場合はメンターに声をかけてください。

#### 1-2. Node.js のインストール

Homebrew がインストールできたら、次は Node.js をインストールします。

```bash
brew install node
```

インストールが完了するまで数分かかる場合があります。文字がたくさん流れますが、エラーが出なければ正常です。

**確認ポイント**

```bash
node --version
```

`v22.x.x` のような番号が表示されれば OK です（`v18` 以上であれば問題ありません）。

```bash
npm --version
```

`10.x.x` のような番号が表示されれば OK です。

> **npm（エヌピーエム）とは?** Node Package Manager の略で、Node.js と一緒にインストールされるツールです。「Node.js 用のアプリストア」のようなもので、Claude Code などのソフトウェアをインストールするときに使います。

[screenshot: node --version と npm --version の両方が表示されている様子]

**うまくいかない場合は**
- `node: command not found` と表示された場合: ターミナルを一度閉じて再度開いてから確認してください。
- Homebrew のインストール自体が失敗している場合: Step 1-1 からやり直してください。
- それでもわからない場合は、メンターを呼んでください。

- [ ] `node --version` でバージョン番号が表示された

---

### Windows の場合

#### 方法 A: winget を使う（推奨）

winget（ウィンゲット）は Windows 10/11 に標準搭載されているパッケージ管理ツールです。Homebrew の Windows 版と思ってください。

PowerShell（パワーシェル）またはコマンドプロンプトを**管理者として実行**して以下を入力してください。

> **管理者として実行するには:** スタートメニューで「PowerShell」を検索し、右クリック → 「管理者として実行」を選択します。「このアプリがデバイスに変更を加えることを許可しますか？」という画面が出たら「はい」をクリックします。

```powershell
winget install OpenJS.NodeJS.LTS
```

[screenshot: スタートメニューで「PowerShell」を右クリックして「管理者として実行」を選択している様子]

**確認ポイント**

```powershell
node --version
```

`v22.x.x` のような番号が表示されれば OK です。

**うまくいかない場合は**
- `winget: コマンドが見つかりません` と表示された場合: 下記の方法 B（公式インストーラー）を使ってください。
- インストールはできたが `node` が認識されない場合: PowerShell を一度閉じて再起動してください。

#### 方法 B: 公式インストーラーを使う

winget がうまくいかない場合の代替方法です。通常のソフトウェアと同じようにインストールできます。

1. ブラウザで `https://nodejs.org` を開く
2. 「LTS」と書かれたボタン（推奨版。Long Term Support = 長期サポート版のこと）をクリックしてインストーラーをダウンロード
3. ダウンロードしたファイルをダブルクリックして指示に従ってインストール
4. インストール途中の「Add to PATH」オプションは必ずチェックを入れたままにする

> **「Add to PATH」とは?** ターミナルから `node` コマンドを使えるようにするための設定です。チェックを外してしまうと、インストールしてもターミナルから使えなくなります。

[screenshot: nodejs.org でLTSボタンをクリックしている様子]

**確認ポイント**

PowerShell を新しく開いてから:

```powershell
node --version
npm --version
```

両方でバージョン番号が表示されれば OK です。

- [ ] `node --version` でバージョン番号が表示された

---

## Step 2: Git のインストール

Git（ジット）はファイルの変更履歴を管理するツールです。

> **Git とは?** Word の「変更履歴を記録する」機能の超強力版です。「昨日の状態に戻したい」「この変更は自分がしたのか AI がしたのか」をいつでも確認・復元できます。Claude Code との連携でも使います。

### Mac の場合

```bash
xcode-select --install
```

ポップアップが表示されたら「インストール」をクリックしてください。すでにインストール済みの場合は `xcode-select: error: command line tools are already installed` というメッセージが表示されます。その場合は次の確認ポイントに進んでください。

[screenshot: 「コマンドラインデベロッパツール」のインストールポップアップが表示されている様子]

**確認ポイント**

```bash
git --version
```

`git version 2.x.x` のような番号が表示されれば OK です。

**うまくいかない場合は**
- インストールに非常に時間がかかる場合: Wi-Fi 接続を確認してください。Xcode Command Line Tools は数百 MB あります。
- Homebrew がすでに入っている場合は代替手段として `brew install git` も使えます。
- うまくいかなければメンターに声をかけてください。

- [ ] `git --version` でバージョン番号が表示された

---

### Windows の場合

Windows の場合は公式サイトからインストーラーをダウンロードします。

1. ブラウザで `https://git-scm.com/download/win` を開く
2. 「Click here to download」リンクをクリックしてインストーラーをダウンロード
3. ダウンロードしたファイルをダブルクリックして起動
4. 基本的にすべてデフォルト設定のまま「Next」をクリックし続けてインストール

> **注意:** 「Choosing the default editor used by Git」の画面では、「Use Visual Studio Code as Git's default editor」を選ぶと後々便利ですが、VS Code が入っていない場合は「Use Notepad as Git's default editor」を選んでください。どちらを選んでも今回の学習には影響ありません。

[screenshot: Git for Windows インストーラーのエディタ選択画面]

**確認ポイント**

PowerShell（または Git Bash）を新しく開いてから:

```powershell
git --version
```

`git version 2.x.x.windows.x` のような番号が表示されれば OK です。

**うまくいかない場合は**
- インストール後に PowerShell を再起動しても認識されない場合: PC を再起動してから再度確認してください。

- [ ] `git --version` でバージョン番号が表示された

---

## Step 3: ターミナル環境の準備

> **ターミナルとは?** コンピュータに「文字で指示を出す画面」のことです。マウスでクリックする代わりに、キーボードでコマンド（命令文）を入力して操作します。最初は慣れないかもしれませんが、今回使うコマンドは限られているので大丈夫です。

### Mac の場合

Terminal.app（ターミナル）が標準搭載されています。

- Finder から: アプリケーション > ユーティリティ > ターミナル
- Spotlight から: `Cmd + Space` を押して「ターミナル」と入力して Enter

これまでの手順で使っていれば、追加の設定は不要です。

**確認ポイント**

ターミナルが開き、以下のような形式のプロンプト（入力待ちの記号）が表示されていれば OK です。

```
username@hostname ~ %
```

この `%` や `$` マークが「入力待ち状態」を意味します。コマンドを入力して Enter を押すと実行されます。

- [ ] ターミナルが開けて、コマンドを入力できる

---

### Windows の場合

Windows にはターミナルの選択肢が複数ありますが、**WSL2 の使用を強く推奨します**。

> **WSL2（Windows Subsystem for Linux 2）とは?** Windows の中に Linux（リナックス）という別の OS を動かす仕組みです。Web 開発の多くのツールは Linux 向けに作られているため、WSL2 を使うと Mac と同じコマンドが使えるようになり、Web 開発がずっとやりやすくなります。

#### 3-1. Windows Terminal のインストール（推奨）

Windows Terminal（ウィンドウズ ターミナル）は、複数のターミナル画面をタブで切り替えられる便利なアプリです。

Microsoft Store を開いて「Windows Terminal」を検索してインストールしてください。または管理者として開いた PowerShell で:

```powershell
winget install Microsoft.WindowsTerminal
```

#### 3-2. WSL2 のセットアップ

**PowerShell を管理者として実行**して以下を入力してください。

```powershell
wsl --install
```

このコマンドは以下を自動で行います:
- WSL2 を有効化する
- Ubuntu（Linux の一種）を自動インストールする

インストールが完了したら **PC を再起動**してください。

[screenshot: PowerShell で wsl --install を実行している様子]

再起動後、Ubuntu が自動起動してユーザー名とパスワードの設定を求められます。

> **注意:** ここで設定する「ユーザー名」と「パスワード」は WSL 内の Linux 専用のものです。Windows のアカウントとは別です。パスワードは入力中に文字が表示されませんが正常です（セキュリティのため非表示になっています）。

[screenshot: Ubuntu の初期設定でユーザー名入力を求める画面]

**確認ポイント**

Windows Terminal を開き、Ubuntu タブを開いて以下を実行してください。

```bash
uname -a
```

`Linux ...` から始まる文字列が表示されれば WSL2 が正常に動いています。

**うまくいかない場合は**
- `wsl --install` が失敗した場合: Windows のバージョンが古い可能性があります。Windows Update で最新版にアップデートしてから再試行してください。
- 「仮想マシンプラットフォーム」が無効と言われた場合: BIOS で仮想化を有効にする必要があります。メンターに確認してください。
- WSL2 のセットアップが難しい場合: PowerShell でそのまま進めることもできますが、一部のコマンドが異なる場合があります。メンターに相談してください。

> **注意:** Windows の場合、以降の手順はすべて **WSL2 の Ubuntu ターミナル内**で実行してください（PowerShell ではありません）。WSL2 内の Node.js は Windows の Node.js とは別にインストールする必要があります。

WSL2 内で Node.js を再インストールします。

```bash
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
node --version
```

- [ ] ターミナルが開けて、コマンドを入力できる
- [ ] （Windows の場合）WSL2 で Ubuntu が起動できる

---

## Step 4: Claude Code のインストール

Node.js がインストールされていれば、`npm` というツールで Claude Code をインストールできます。

> **なぜ npm を使うの?** Claude Code は npm（Node.js のアプリストア）で配布されています。`npm install` コマンドは「アプリをダウンロードしてインストールする」ことを意味します。

```bash
npm install -g @anthropic-ai/claude-code
```

> **`-g` って何?** 「global（グローバル）」の略です。「このパソコンのどこからでも使えるようにインストールする」という意味です。`-g` なしでインストールすると、特定のフォルダの中だけでしか使えません。

**確認ポイント**

```bash
claude --version
```

`claude/x.x.x ...` のようなバージョン情報が表示されれば OK です。

[screenshot: claude --version を実行してバージョンが表示されている様子]

**うまくいかない場合は**
- `EACCES: permission denied` エラーが出た場合（Mac）: 以下を試してください。
  ```bash
  sudo npm install -g @anthropic-ai/claude-code
  ```
  `sudo`（スードゥ）は「管理者権限で実行する」という意味です。Mac のパスワードを求められます。それでも解決しない場合は、Node.js を Homebrew 経由で再インストールすると解決することが多いです。
- `claude: command not found` と表示された場合: ターミナルを再起動してから再度確認してください。
- Windows（WSL2）で `EACCES` エラーが出た場合: `sudo` を付けて再実行してください。
- それでも解決しない場合は、メンターに声をかけてください。

- [ ] `claude --version` でバージョン番号が表示された

---

## Step 5: API Key の取得と設定

Claude Code を使うには Anthropic（アンソロピック）の API Key が必要です。

> **API Key（エーピーアイ キー）とは?** API（Application Programming Interface）は、外部サービスを利用するための「窓口」のようなものです。API Key はその窓口を通るための「合言葉（パスワード）」です。この Key がないと Claude のサービスを使えません。

### 5-1. API Key の取得

1. ブラウザで `https://console.anthropic.com` を開く
2. アカウントを持っていない場合は「Sign up」から登録する（メールアドレスがあれば登録できます）
3. ログイン後、左サイドバーの「API Keys」をクリック
4. 「Create Key」ボタンをクリック
5. Key の名前を入力（例: `claude-code-local`。どんな名前でも OK です）して「Create Key」をクリック
6. 表示された Key（`sk-ant-...` で始まる長い文字列）をコピーして**安全な場所に保存する**

[screenshot: Anthropic Console の API Keys ページで「Create Key」ボタンが表示されている様子]

[screenshot: 生成された API Key が表示されているモーダル画面]

> **重要:** API Key は**一度しか表示されません**。必ずコピーしてパスワードマネージャーや安全なメモに保存してください。紛失した場合は新しいキーを作成する必要があります。
>
> また、API Key は**絶対に他人に見せたり、GitHub などの公開サービスに投稿したりしないでください**。悪用されると課金が発生します。クレジットカード番号と同じくらい大切に扱ってください。

### 5-2. API Key の設定

取得した API Key を、ターミナルが起動するたびに自動で読み込まれるように設定します。

> **なぜ設定ファイルに書くの?** Claude Code を起動するたびに「API Key はこれです」と入力するのは大変です。設定ファイルに一度書いておけば、ターミナルを開くたびに自動で読み込まれます。

#### Mac の場合

ターミナルで以下を実行します。`sk-ant-...` の部分を先ほどコピーした実際のキーに置き換えてください。

```bash
echo 'export ANTHROPIC_API_KEY="sk-ant-ここに実際のキーを貼り付ける"' >> ~/.zprofile
source ~/.zprofile
```

> **`~/.zprofile` とは?** ターミナル（zsh という種類のシェル）を起動するたびに自動で読み込まれる設定ファイルです。`>>` は「このファイルの末尾に追記する」という意味です。bash を使っている場合は `~/.zprofile` の代わりに `~/.bash_profile` を使ってください。どちらを使っているか分からない場合は `echo $SHELL` を実行して確認できます。

**確認ポイント**

```bash
echo $ANTHROPIC_API_KEY
```

`sk-ant-...` で始まる文字列が表示されれば OK です。

**うまくいかない場合は**
- 設定が反映されない場合: ターミナルを閉じて開き直してから `echo $ANTHROPIC_API_KEY` を再確認してください。
- キーを間違えてファイルに書き込んでしまった場合: `~/.zprofile` をテキストエディタで開いて修正してください。メンターに声をかけても OK です。

---

#### Windows（WSL2）の場合

WSL2 の Ubuntu ターミナルで以下を実行します。

```bash
echo 'export ANTHROPIC_API_KEY="sk-ant-ここに実際のキーを貼り付ける"' >> ~/.bashrc
source ~/.bashrc
```

**確認ポイント**

```bash
echo $ANTHROPIC_API_KEY
```

`sk-ant-...` で始まる文字列が表示されれば OK です。

**うまくいかない場合は**
- ターミナルを閉じて開き直してから再確認してください。

---

### 5-3. Claude Code の初回起動

いよいよ Claude Code を実際に動かしてみましょう。ここまでの全手順の集大成です。

```bash
claude
```

[screenshot: claude コマンドを実行して「Welcome to Claude Code」のような画面が表示されている様子]

`>` または `?` のようなプロンプト（入力待ち記号）が表示されたら起動成功です。

試しに以下を入力してみてください。

```
こんにちは！
```

Claude から返答が来れば完璧です。終了するには `/exit` と入力するか、`Ctrl + C` を押してください。

**うまくいかない場合は**
- `Invalid API key` や `Authentication error` と表示された場合: `echo $ANTHROPIC_API_KEY` で API Key が正しく設定されているか確認してください。キーの前後に余分なスペースや改行が入っていないかも確認してください。
- `Error: No API key found` と表示された場合: Step 5-2 を最初からやり直してください。ターミナルを再起動することも試してください。
- 応答が非常に遅い場合: ネットワーク接続を確認してください。
- それでも解決しない場合は、メンターに声をかけてください。

- [ ] `claude` コマンドで Claude Code が起動した
- [ ] Claude に話しかけて返答が来た

---

## 完了チェックリスト

Module 0 が完了したら、以下がすべてチェックできているはずです。

- [ ] `node --version` でバージョン番号が表示される
- [ ] `npm --version` でバージョン番号が表示される
- [ ] `git --version` でバージョン番号が表示される
- [ ] `claude --version` でバージョン番号が表示される
- [ ] `claude` コマンドで Claude Code が起動して会話できる

---

## このモジュールのまとめ

このモジュールでは、Claude Code を使うための土台を整えました。

- **Node.js と npm** をインストールし、Claude Code を動かすエンジンを用意しました
- **Git** をインストールし、ファイルの変更履歴を管理できるようにしました
- **ターミナル環境**（Mac は Terminal.app、Windows は WSL2）を整えました
- **Claude Code** をインストールし、`claude` コマンドで起動できるようになりました
- **API Key** を取得・設定し、Claude のサービスと接続できるようになりました

次の Module 1 では、Claude Code に「プロジェクトの説明書（CLAUDE.md）」を作成し、Slack や Figma と連携する MCP プラグインを設定します。

すべてチェックできたら **Module 1** に進んでください。お疲れさまでした。

---

## 随時追記セクション

> このセクションには、後のモジュールで必要になるツールやアカウントをまとめています。
> 各モジュールに進む前に、該当する項目を準備してください。

---

### Figma アカウント + Personal Access Token（Module 1 で使用）

Module 3 で Figma MCP サーバーを使って UI デザインを作成します。事前に準備しておきましょう。

1. [Figma](https://www.figma.com/) にアクセスしてアカウントを作成（無料プランでOK）
2. Personal Access Token を発行:
   - Figma にログイン → 左上のアイコン → **Settings**
   - **Personal access tokens** セクションで **Generate new token** をクリック
   - トークン名を入力（例: `claude-code`）→ **Generate token**
   - 表示されたトークン（`figd_` で始まる文字列）をコピーして安全な場所に保存

> **注意:** トークンは一度しか表示されません。忘れた場合は新しく発行してください。

- [ ] Figma アカウントを作成した
- [ ] Personal Access Token を発行して保存した

---

### Supabase アカウント + supabase-js（Module 4 で使用）

Module 4 で Supabase（データベースと認証を提供するクラウドサービス）を使います。

1. [Supabase](https://supabase.com/) にアクセスしてアカウントを作成（GitHub 連携が簡単）
2. パッケージのインストール（プロジェクトディレクトリで実行）:

```bash
npm install @supabase/supabase-js
```

3. Module 4 で Supabase プロジェクトを作成した後、`.env.local` に接続情報を設定します:

```bash
NEXT_PUBLIC_SUPABASE_URL=your-project-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```

> **注意:** `.env.local` は `.gitignore` に含まれていることを確認してください。秘密の情報が外部に漏れるのを防ぎます。

- [ ] Supabase アカウントを作成した
- [ ] `@supabase/supabase-js` をインストールした

---

### 認証パッケージ（Module 5 で使用）

Module 5 で SPA ベースのログイン認証を実装します。以下のパッケージを追加インストールしてください。

```bash
npm install @supabase/ssr
```

`@supabase/ssr` は、Supabase の認証機能を Next.js で使うためのヘルパーパッケージです。

- [ ] `@supabase/ssr` をインストールした

---

### Vercel アカウント + Vercel CLI（Module 7 で使用）

Module 7 でアプリをインターネットに公開（デプロイ）します。

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

*最終更新: 2026-02-18*
