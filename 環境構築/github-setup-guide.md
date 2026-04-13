# GitHub & Claude Code 環境構築ガイド

新しいPCで同じ開発環境をすぐに再現するための手順書です。

---

## 目次

1. [必要なツールのインストール](#1-必要なツールのインストール)
2. [Gitの初期設定](#2-gitの初期設定)
3. [GitHubとの連携](#3-githubとの連携)
4. [既存リポジトリの取得](#4-既存リポジトリの取得)
5. [Claude Codeのセットアップ](#5-claude-codeのセットアップ)
6. [自動コミットの設定](#6-自動コミットの設定)
7. [日常の作業フロー](#7-日常の作業フロー)
8. [バージョン管理チートシート](#8-バージョン管理チートシート)

---

## 1. 必要なツールのインストール

| ツール | ダウンロード先 | 用途 |
|---|---|---|
| Git | https://git-scm.com | バージョン管理 |
| VS Code | https://code.visualstudio.com | コードエディタ |
| Claude Code | https://claude.ai/code | AIアシスタントCLI |

インストール確認：
```bash
git --version
code --version
claude --version
```

---

## 2. Gitの初期設定

**インストール後に必ず一度だけ実行する。**

```bash
git config --global user.name "あなたの名前"
git config --global user.email "your@email.com"
```

設定確認：
```bash
git config --list
```

---

## 3. GitHubとの連携

### GitHubアカウント
- アカウント名：shoteacherj-web
- URL：https://github.com/shoteacherj-web

### 認証（Personal Access Token）
1. GitHub → Settings → Developer settings → Personal access tokens
2. 「Generate new token」をクリック
3. 権限：`repo` にチェック
4. 生成されたトークンをパスワードとして使用

---

## 4. 既存リポジトリの取得

新しいPCでは `setup.sh` を実行するだけで全リポジトリが揃います。

```bash
bash setup.sh
```

または手動で個別にclone：

```bash
# 作業フォルダを作成
mkdir -p ~/AI開発
cd ~/AI開発

# 各リポジトリをclone
git clone https://github.com/shoteacherj-web/ai-secretary.git
git clone https://github.com/shoteacherj-web/joba-agent.git
git clone https://github.com/shoteacherj-web/Figma-Design.git
git clone https://github.com/shoteacherj-web/git-practice.git
git clone https://github.com/shoteacherj-web/google-ai-studio.git
git clone https://github.com/shoteacherj-web/wp-theme-template.git
```

---

## 5. Claude Codeのセットアップ

```bash
# Claude Codeにログイン
claude auth login
```

設定ファイル（`~/.claude/settings.json`）を以下の内容で作成：

```json
{
  "language": "ja",
  "autoUpdatesChannel": "latest",
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/scripts/auto_commit.sh"
          }
        ]
      }
    ]
  }
}
```

---

## 6. 自動コミットの設定

`auto_commit.sh` を `~/.claude/scripts/` に配置します。

```bash
mkdir -p ~/.claude/scripts
cp 環境構築/auto_commit.sh ~/.claude/scripts/auto_commit.sh
```

これで **Claude Codeで作業が終わるたびに自動でコミット**されます。

### 自動コミットの仕組み

```
Claude Codeで作業
    ↓
返答が終わるたびに自動実行
    ↓
AI開発フォルダ内の全リポジトリをチェック
    ↓
変更があれば自動でコミット（例：auto: [JOBA] main.py を更新）
```

---

## 7. 日常の作業フロー

### 毎朝（作業開始前）
```bash
git pull origin main   # 最新の状態を取得
```

### 作業中
- ファイルを編集する
- Claude Codeが自動でコミット（手動でも可）

### 作業終了時
```bash
git push origin main   # GitHubに送信
```

または Claude Codeに「今日の変更をpushしておいて」と伝えるだけでOK。

---

## 8. バージョン管理チートシート

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
```

### よく使うClaude Codeへの指示

```
「今日の変更をコミットしてpushしておいて」
「〇〇ブランチを作って変更を上げておいて」
「変更を全部コミットしておいて」
「v1の状態に戻して」
```

---

## トラブルシューティング

### pushできない場合
```bash
# 認証エラーの場合はトークンを再設定
git remote set-url origin https://[トークン]@github.com/shoteacherj-web/[リポジトリ名].git
```

### 最新が取得できない場合
```bash
git fetch origin
git pull origin main
```

### 間違えてコミットした場合
```bash
# 直前のコミットを取り消す（ファイルは残る）
git revert HEAD
```
