# ifrku-website

ifrku の公式ブログ。ソースは Markdown、ビルドツールは Gradle、Jekyll で静的サイトを生成し GitHub Pages で公開します。

## リポジトリ構成

```
ifrku-website/
├── site/                        # ← Webサイトのソースコード（Jekyll）
│   ├── _config.yml              #   Jekyll設定ファイル
│   ├── _layouts/                #   レイアウトテンプレート
│   ├── _plugins/                #   カスタムJekyllプラグイン
│   ├── _posts/                  #   ブログ記事（Markdown）
│   ├── assets/                  #   静的ファイル（CSS・画像）
│   ├── index.html               #   トップページ
│   ├── about.md                 #   サイト紹介ページ
│   └── Gemfile                  #   Ruby依存関係定義
├── build.gradle.kts             # Gradleビルドスクリプト
├── settings.gradle.kts          # Gradleプロジェクト設定
├── gradlew / gradlew.bat        # Gradleラッパー
└── .github/workflows/deploy.yml # GitHub Actions（自動デプロイ）
```

## ローカル開発

```bash
# Jekyll サイトをビルドする（site/_site/ に出力）
./gradlew jekyllBuild

# ローカルサーバー起動（ライブリロード対応）
./gradlew jekyllServe
```

## キャラクターブロック

Markdown 内で以下のように書くとキャラクターの吹き出しになります。

```
zundamon: ハローなのだ
```

キャラクター画像は `site/assets/images/characters/` に PNG ファイルを配置してください。詳細は [site/assets/images/characters/README.md](site/assets/images/characters/README.md) を参照。

## ブログ記事の追加

`site/_posts/` ディレクトリに `YYYY-MM-DD-title.md` の形式でファイルを作成してください。

```yaml
---
layout: post
title: "記事タイトル"
date: 2024-01-01 12:00:00 +0900
tags: [タグ1, タグ2]
---

記事本文…
```

## CI/CD

`main` ブランチへの push ごとに GitHub Actions が自動でビルド・デプロイします。