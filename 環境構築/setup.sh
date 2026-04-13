#!/bin/bash
# ============================================
# 新しいPCセットアップスクリプト
# 実行するだけで開発環境が整います
# 使い方：bash setup.sh
# ============================================

echo "======================================"
echo "  開発環境セットアップを開始します"
echo "======================================"

# ------------------------------
# 1. Gitの設定
# ------------------------------
echo ""
echo "【Step 1】Gitのユーザー設定"
echo "GitHubに登録した名前とメールアドレスを入力してください。"

read -p "名前：" GIT_NAME
read -p "メールアドレス：" GIT_EMAIL

git config --global user.name "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
echo "✓ Git設定完了"

# ------------------------------
# 2. GitHubアカウントの確認
# ------------------------------
echo ""
echo "【Step 2】GitHubアカウントの設定"
echo "使用するGitHubアカウント名を入力してください。"
echo "（例：会社アカウントなら会社のユーザー名、個人なら shoteacherj-web）"
echo ""

read -p "GitHubアカウント名：" GITHUB_USER
echo "✓ GitHubアカウント：$GITHUB_USER"

# ------------------------------
# 3. 作業フォルダの作成
# ------------------------------
echo ""
echo "【Step 3】作業フォルダの作成"
echo "リポジトリを保存するフォルダのパスを入力してください。"
echo "（そのままEnterを押すとデフォルトのパスになります）"

# OSに応じてデフォルトパスを設定
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
  DEFAULT_DIR="$USERPROFILE/Documents/AI開発"
else
  DEFAULT_DIR="$HOME/AI開発"
fi

read -p "作業フォルダ [$DEFAULT_DIR]：" BASE_DIR
BASE_DIR="${BASE_DIR:-$DEFAULT_DIR}"

mkdir -p "$BASE_DIR"
echo "✓ 作業フォルダ作成：$BASE_DIR"

# ------------------------------
# 4. リポジトリのclone
# ------------------------------
echo ""
echo "【Step 4】GitHubからリポジトリを取得"
echo "cloneするリポジトリ名を入力してください（複数可）。"
echo "1行に1つ入力し、終わったら空のままEnterを押してください。"
echo "（個人リポジトリを会社PCに入れる場合はそのまま入力してOKです）"
echo ""

REPOS=()
while true; do
  read -p "リポジトリ名（空でスキップ）：" REPO_NAME
  [ -z "$REPO_NAME" ] && break
  REPOS+=("$REPO_NAME")
done

if [ ${#REPOS[@]} -eq 0 ]; then
  echo "  → リポジトリの取得をスキップしました"
else
  cd "$BASE_DIR"
  for REPO in "${REPOS[@]}"; do
    if [ -d "$REPO" ]; then
      echo "  → $REPO は既に存在します。最新を取得します..."
      cd "$REPO" && git pull origin main 2>/dev/null || git pull origin master 2>/dev/null
      cd "$BASE_DIR"
    else
      echo "  → $REPO をclone中..."
      git clone "https://github.com/$GITHUB_USER/$REPO.git"
    fi
  done
  echo "✓ リポジトリ取得完了"
fi

# ------------------------------
# 5. Claude Code 自動コミット設定
# ------------------------------
echo ""
echo "【Step 5】Claude Code 自動コミット設定"

CLAUDE_SCRIPTS="$HOME/.claude/scripts"
CLAUDE_SETTINGS="$HOME/.claude/settings.json"

mkdir -p "$CLAUDE_SCRIPTS"

# auto_commit.shをコピーしてパスを書き換え
SCRIPT_SRC="$(dirname "$0")/auto_commit.sh"
SCRIPT_DST="$CLAUDE_SCRIPTS/auto_commit.sh"

if [ -f "$SCRIPT_SRC" ]; then
  # BASE_DIRを実際のパスに書き換えてコピー
  sed "s|C:/Users/jo-sh/OneDrive/ドキュメント/AI開発|$BASE_DIR|g" "$SCRIPT_SRC" > "$SCRIPT_DST"
  echo "✓ auto_commit.sh を配置しました（パス：$SCRIPT_DST）"
else
  echo "  ⚠ auto_commit.sh が見つかりません。手動でコピーしてください。"
fi

# settings.jsonを作成
if [ -f "$CLAUDE_SETTINGS" ]; then
  echo ""
  read -p "  settings.jsonが既に存在します。上書きしますか？(y/n)：" OVERWRITE
fi

if [ ! -f "$CLAUDE_SETTINGS" ] || [ "$OVERWRITE" = "y" ]; then
  cat > "$CLAUDE_SETTINGS" << EOF
{
  "language": "ja",
  "autoUpdatesChannel": "latest",
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash $SCRIPT_DST"
          }
        ]
      }
    ]
  }
}
EOF
  echo "✓ Claude Code設定完了"
fi

# ------------------------------
# 完了
# ------------------------------
echo ""
echo "======================================"
echo "  セットアップ完了！"
echo "======================================"
echo ""
echo "次のステップ："
echo "  1. claude auth login  でClaude Codeにログイン"
echo "  2. 作業フォルダ：$BASE_DIR"
echo "  3. 詳細は github-setup-guide.md を参照"
echo ""
