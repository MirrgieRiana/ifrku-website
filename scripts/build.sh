#!/usr/bin/env bash
# scripts/build.sh — Jekyll サイトのビルドスクリプト
#
# このスクリプトはGradleから呼び出されます（build.gradle.kts の jekyllBuild タスク）。
# 処理の流れ:
#   1. contents/blog/ のブログ記事を ai/_posts/ にコピー
#   2. contents/about.md を ai/about.md にコピー
#   3. ai/ ディレクトリで bundle install を実行
#   4. jekyll build（または jekyll serve）を実行
#
# 使い方:
#   bash scripts/build.sh         # ビルドモード（デフォルト）
#   bash scripts/build.sh serve   # ローカルサーバーモード（ライブリロード付き）

set -euo pipefail

# スクリプトの場所からリポジトリルートを算出
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# 第1引数が "serve" ならサーバー起動モード、それ以外はビルドモード
MODE="${1:-build}"

echo "==> [1/3] コンテンツを ai/ にコピー中..."

# ブログ記事を ai/_posts/ にコピー（contents/blog/ が空でもエラーにしない）
mkdir -p "${REPO_ROOT}/ai/_posts"
if [ -d "${REPO_ROOT}/contents/blog" ]; then
  cp -r "${REPO_ROOT}/contents/blog/." "${REPO_ROOT}/ai/_posts/"
fi

# about ページを ai/about.md にコピー
if [ -f "${REPO_ROOT}/contents/about.md" ]; then
  cp "${REPO_ROOT}/contents/about.md" "${REPO_ROOT}/ai/about.md"
fi

echo "==> [2/3] Gem 依存関係をインストール中..."
cd "${REPO_ROOT}/ai"

# bundler コマンドを検出（bundle がなければ bundle3.x 系を順番に探す）
BUNDLE_CMD="bundle"
if ! command -v bundle >/dev/null 2>&1; then
  BUNDLE_CMD=""
  for cmd in bundle3.3 bundle3.2 bundle3.1 bundle3.0; do
    if command -v "${cmd}" >/dev/null 2>&1; then
      BUNDLE_CMD="${cmd}"
      break
    fi
  done
  if [ -z "${BUNDLE_CMD}" ]; then
    echo "エラー: bundler が見つかりません。gem install bundler を実行してください。" >&2
    exit 1
  fi
  echo "  (bundler コマンド: ${BUNDLE_CMD})"
fi

"${BUNDLE_CMD}" install

echo "==> [3/3] Jekyll を起動中（モード: ${MODE}）..."
if [ "${MODE}" = "serve" ]; then
  # ローカル開発用: ライブリロード付きサーバー起動
  "${BUNDLE_CMD}" exec jekyll serve --livereload
else
  # CI/本番ビルド
  "${BUNDLE_CMD}" exec jekyll build
  echo "==> ビルド完了！ai/_site/ に出力されました。"
fi
