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
# 2. 作業フォルダの作成
# ------------------------------
echo ""
echo "【Step 2】作業フォルダの作成"

# Windowsの場合はドキュメントフォルダに作成
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
  BASE_DIR="$USERPROFILE/OneDrive/ドキュメント/AI開発"
else
  BASE_DIR="$HOME/AI開発"
fi

mkdir -p "$BASE_DIR"
echo "✓ 作業フォルダ作成：$BASE_DIR"

# ------------------------------
# 3. リポジトリのclone
# ------------------------------
echo ""
echo "【Step 3】GitHubからリポジトリを取得"

GITHUB_USER="shoteacherj-web"
REPOS=(
  "ai-secretary"
  "joba-agent"
  "Figma-Design"
  "git-practice"
  "google-ai-studio"
  "wp-theme-template"
)

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

# ------------------------------
# 4. Claude Code 自動コミット設定
# ------------------------------
echo ""
echo "【Step 4】Claude Code 自動コミット設定"

CLAUDE_SCRIPTS="$HOME/.claude/scripts"
CLAUDE_SETTINGS="$HOME/.claude/settings.json"

mkdir -p "$CLAUDE_SCRIPTS"

# auto_commit.shをコピー
cp "$BASE_DIR/git-practice/環境構築/auto_commit.sh" "$CLAUDE_SCRIPTS/auto_commit.sh"
echo "✓ auto_commit.sh を配置しました"

# settings.jsonを作成（既存の場合は上書き確認）
if [ -f "$CLAUDE_SETTINGS" ]; then
  echo ""
  read -p "  settings.jsonが既に存在します。上書きしますか？(y/n)：" OVERWRITE
  if [ "$OVERWRITE" != "y" ]; then
    echo "  → settings.jsonの更新をスキップしました"
    echo "  ※ 手動で github-setup-guide.md の内容を参考に設定してください"
  fi
fi

if [ ! -f "$CLAUDE_SETTINGS" ] || [ "$OVERWRITE" = "y" ]; then
  cat > "$CLAUDE_SETTINGS" << 'EOF'
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
