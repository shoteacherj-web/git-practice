# GitHub & Claude Code 環境構築ガイド

新しいPCで同じ開発環境をすぐに再現するための手順書です。
**会社PCでも個人PCでも同じ手順で使えます。**

---

## 目次

1. [必要なツールのインストール](#1-必要なツールのインストール)
2. [セットアップスクリプトの実行](#2-セットアップスクリプトの実行)
3. [Claude Codeへのログイン](#3-claude-codeへのログイン)
4. [複数アカウントの使い分け](#4-複数アカウントの使い分け)
5. [日常の作業フロー](#5-日常の作業フロー)
6. [バージョン管理チートシート](#6-バージョン管理チートシート)
7. [トラブルシューティング](#7-トラブルシューティング)

---

## 1. 必要なツールのインストール

以下の3つをインストールしてください。

| ツール | ダウンロード先 | 用途 |
|---|---|---|
| Git | https://git-scm.com | バージョン管理 |
| VS Code | https://code.visualstudio.com | コードエディタ |
| Claude Code | https://claude.ai/code | AIアシスタントCLI |

インストール後、確認コマンド：
```bash
git --version
code --version
claude --version
```

---

## 2. セットアップスクリプトの実行

このフォルダにある `setup.sh` を実行するだけで環境が整います。

```bash
bash setup.sh
```

実行すると以下を順番に質問されます：

```
名前：              ← GitHubに登録した名前
メールアドレス：    ← GitHubに登録したメールアドレス
GitHubアカウント名：← 使用するアカウント名（会社 or 個人）
作業フォルダ：      ← リポジトリを保存する場所（Enterでデフォルト）
リポジトリ名：      ← cloneしたいリポジトリ名を1つずつ入力
```

---

## 3. Claude Codeへのログイン

```bash
claude auth login
```

ブラウザが開くのでログインしてください。

---

## 4. 複数アカウントの使い分け

**会社PCで個人アカウントと会社アカウントを使い分ける方法です。**

### 基本の考え方

```
グローバル設定  → 会社アカウント（デフォルト）
リポジトリ個別  → 個人アカウント（必要な時だけ切り替え）
```

### 会社アカウントをデフォルトに設定

```bash
git config --global user.name "会社の名前"
git config --global user.email "会社のメール@company.com"
```

### 個人リポジトリだけ個人アカウントに切り替える

```bash
# 個人のリポジトリフォルダに移動してから実行
cd ~/AI開発/git-practice
git config user.name "個人の名前"
git config user.email "個人のメール@gmail.com"
```

※ この設定はそのフォルダだけに適用されます。

### 個人リポジトリをcloneする場合

```bash
# アカウント名を明示してclone
git clone https://shoteacherj-web@github.com/shoteacherj-web/リポジトリ名.git
```

### 現在の設定を確認する

```bash
# グローバル設定の確認
git config --global user.email

# 現在のリポジトリの設定確認
git config user.email
```

---

## 5. 日常の作業フロー

### 毎朝（作業開始前）

```bash
git pull origin main   # 最新の状態を取得
```

### 作業中

- ファイルを編集するだけでOK
- Claude Codeが作業終了時に**自動でコミット**してくれます

### 作業終了時

```bash
git push origin main   # GitHubに送信
```

または Claude Codeに一言：
```
「今日の変更をpushしておいて」
```

### Claude Codeへの便利な指示例

```
「今日の変更をコミットしてpushしておいて」
「〇〇ブランチを作って変更を上げておいて」
「変更を全部コミットしておいて」
「v1の状態に戻して」
```

---

## 6. バージョン管理チートシート

```bash
# 状態確認（一番よく使う）
git status

# 変更を記録する準備
git add .

# コメント付きで保存
git commit -m "変更内容のメモ"

# GitHubに送信
git push origin main

# GitHubから最新を取得
git pull origin main

# 履歴を確認
git log --oneline

# 特定のバージョンに戻す
git checkout [コミットID] -- ファイル名

# 新しいブランチを作る
git checkout -b ブランチ名

# ブランチを切り替える
git checkout ブランチ名

# ブランチをmainに合体させる
git merge ブランチ名
```

### バージョン管理のポイント

```
❌ バックアップファイルを作る必要はない
   index_backup.html
   index_最終版.html   ← これは不要！

✅ ファイルは1つ、履歴はGitが管理
   index.html          ← これだけでOK
```

---

## 7. トラブルシューティング

### pushできない（認証エラー）

```bash
# Personal Access Tokenを使って認証する
# GitHub → Settings → Developer settings → Personal access tokens
# 生成したトークンをパスワードとして使用

git remote set-url origin https://[アカウント名]@github.com/[アカウント名]/[リポジトリ名].git
```

### 最新が取得できない

```bash
git fetch origin
git pull origin main
```

### 間違えてコミットした

```bash
# 直前のコミットを取り消す（ファイルは残る）
git revert HEAD
```

### どのアカウントで操作しているか確認したい

```bash
git config user.email
```

---

## 付属ファイル

| ファイル名 | 内容 |
|---|---|
| `setup.sh` | 新PC用一括セットアップスクリプト |
| `auto_commit.sh` | 自動コミットスクリプト |
| `github-setup-guide.md` | この手順書 |
