# Git / GitHub 社内導入ガイド（Phase 1）
Web制作会社向け・FTP運用からの移行ステップ

---

## 目的

- ローカルバックアップをGitに置き換える
- 「誰が・いつ・何を変えたか」を履歴として残す
- FTPの運用はそのまま維持しながら導入できる

---

## 必要なもの

| ツール | 用途 | 入手先 |
|--------|------|--------|
| Git | バージョン管理ツール本体 | https://git-scm.com |
| GitHub アカウント | コードの保管場所 | https://github.com |
| GitHub Desktop（推奨） | Git操作をGUI化（コマンド不要） | https://desktop.github.com |

---

## ステップ1：Git をインストールする

1. https://git-scm.com からインストーラーをダウンロード
2. インストーラーを実行（設定はすべてデフォルトでOK）
3. インストール確認：コマンドプロンプトで以下を実行
   ```
   git --version
   ```
   バージョン番号が表示されればOK

---

## ステップ2：GitHub アカウントを作成する

1. https://github.com にアクセス
2. 「Sign up」からアカウント登録
3. プランは **Free** で開始（後からチームプランに変更可能）

---

## ステップ3：GitHub Desktop をインストールする

1. https://desktop.github.com からダウンロード・インストール
2. 起動後、GitHubアカウントでサインイン
3. コマンドを使わずGUIでGit操作が可能になる

---

## ステップ4：既存案件を Git 管理に移行する

### 4-1. リポジトリを作成する

1. GitHub Desktop を開く
2. 「File」→「New Repository」
3. 以下を設定：
   - **Name**：案件名（例：`client-a-website`）
   - **Local Path**：既存のサイトフォルダを指定
   - **Private** にチェック（社外秘の場合）
4. 「Create Repository」をクリック

### 4-2. 現在のファイルを最初のコミットとして記録する

1. GitHub Desktop 左側に変更ファイルが一覧表示される
2. 左下の「Summary」に `初期コミット` と入力
3. 「Commit to main」をクリック
4. 「Publish repository」→ GitHubにアップロード完了

---

## ステップ5：日常の運用フロー

```
① サイトを修正する
    ↓
② GitHub Desktop で変更内容を確認する
    ↓
③ Summary に変更内容を一言で入力
    （例：「トップページのバナー画像を差し替え」）
    ↓
④ 「Commit to main」をクリック
    ↓
⑤ 「Push origin」でGitHubに同期
    ↓
⑥ 今まで通り FTP で本番環境にアップ
```

---

## コミットメッセージの書き方（例）

| 良い例 | 悪い例 |
|--------|--------|
| `トップのスライダー画像を3枚に変更` | `修正` |
| `会社概要ページの電話番号を更新` | `更新` |
| `SP表示のナビ崩れを修正` | `直した` |

---

## よくある操作

### 以前のバージョンに戻したい

1. GitHub Desktop の「History」タブを開く
2. 戻りたいコミットを右クリック
3. 「Revert Changes in Commit」を選択

### 変更内容をあとから確認したい

1. GitHub Desktop の「History」タブを開く
2. 各コミットをクリックすると差分が確認できる

---

## 次のステップ（Phase 2 以降）

慣れてきたら以下も検討：

- **ブランチ運用**：案件・改修ごとにブランチを作り、レビュー後にマージ
- **チームプラン（$4/人/月）**：複数人での権限管理・レビュー機能
- **自動デプロイ**：GitHub にプッシュしたら自動で本番反映（FTP不要）

---

## 困ったときの参考資料

- Git 公式ドキュメント（日本語）：https://git-scm.com/book/ja/v2
- GitHub Desktop 使い方：https://docs.github.com/ja/desktop
- GitHub 日本語サポート：https://support.github.com

---

作成日：2026-04-12
