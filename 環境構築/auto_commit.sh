#!/bin/bash
# ============================================
# 自動コミットスクリプト
# Claude Codeの作業終了時に自動で実行される
# 使い方：bash auto_commit.sh
# ============================================

# setup.shによって自動的に正しいパスに書き換えられます
BASE_DIR="C:/Users/jo-sh/OneDrive/ドキュメント/AI開発"

# ベースディレクトリが存在しない場合はカレントディレクトリを使用
if [ ! -d "$BASE_DIR" ]; then
  BASE_DIR=$(pwd)
fi

for dir in "$BASE_DIR"/*/; do
  # .gitフォルダがある（=gitリポジトリ）のみ対象
  if [ ! -d "$dir/.git" ]; then
    continue
  fi

  cd "$dir"

  # 変更がなければスキップ
  MODIFIED=$(git diff --name-only 2>/dev/null)
  STAGED=$(git diff --staged --name-only 2>/dev/null)
  UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null)

  if [ -z "$MODIFIED" ] && [ -z "$STAGED" ] && [ -z "$UNTRACKED" ]; then
    continue
  fi

  # 変更されたファイル一覧を取得（最大3件）
  ALL_CHANGED=$(printf "%s\n%s\n%s" "$MODIFIED" "$STAGED" "$UNTRACKED" | grep -v '^$' | sort -u | head -3)

  # ファイルリストを整形
  FILE_LIST=$(echo "$ALL_CHANGED" | tr '\n' '、' | sed 's/、$//')
  PROJECT=$(basename "$dir")

  # 変更の種類を判定してメッセージ生成
  if [ -n "$UNTRACKED" ] && [ -z "$MODIFIED" ]; then
    ACTION="追加"
  elif [ -z "$UNTRACKED" ] && [ -n "$MODIFIED" ]; then
    ACTION="更新"
  else
    ACTION="追加・更新"
  fi

  COMMIT_MSG="auto: [${PROJECT}] ${FILE_LIST} を${ACTION}"

  git add -A
  git commit -m "$COMMIT_MSG"

  echo "✓ コミット完了: $COMMIT_MSG"
done
