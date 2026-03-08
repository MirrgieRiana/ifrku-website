# ifrku-website

ifrku の公式ブログ。ソースは Markdown、ビルドツールは Gradle、Jekyll で静的サイトを生成し GitHub Pages で公開します。

---

## ✏️ ブログ記事を書きたい方へ（人間向け）

**`contents/` ディレクトリ**に記事や固定ページを置いてください。ここは人間が直接編集するエリアです。

```
contents/
├── blog/                        # ← ブログ記事（ここにMDファイルを追加）
│   ├── 2024-01-01-welcome.md
│   └── 2024-01-15-gradle-jekyll-setup.md
└── about.md                     # サイト紹介ページ
```

### ブログ記事の追加方法

`contents/blog/` に `YYYY-MM-DD-タイトル.md` の形式でファイルを作成してください。

```yaml
---
layout: post
title: "記事タイトル"
date: 2024-01-01 12:00:00 +0900
tags: [タグ1, タグ2]
---

記事本文（Markdownで書けます）
```

### キャラクターブロック

記事内でキャラクターの吹き出しを表示できます。

```
zundamon: ハローなのだ
```

キャラクター画像は `ai/assets/images/characters/<キー名>.png` に配置してください。
（画像がなくても絵文字でフォールバック表示されます）

---

## 🤖 `ai/` ディレクトリについて

**`ai/` ディレクトリはAIコーディングアシスタントが主に管理しています。**
人間はあまり立ち入らないことを想定したディレクトリです。

具体的には、次のような要素が含まれます：

- Jekyll のレイアウトテンプレート（`_layouts/`）
- カスタムRubyプラグイン（`_plugins/`）
- CSS スタイルシート（`assets/css/style.css`）
- Jekyll 設定ファイル（`_config.yml`）
- Gemfile

> **注意**: `ai/_posts/` と `ai/about.md` はビルド時に `scripts/build.sh` によって `contents/` から自動コピーされます。
> 直接編集しても次回ビルドで上書きされるため、記事の編集は必ず `contents/` 側で行ってください。

---

## 🔨 ローカルでビルドする方法

```bash
# Jekyll サイトをビルドする（ai/_site/ に出力）
./gradlew jekyllBuild

# ローカルサーバー起動（ライブリロード対応）
./gradlew jekyllServe
```

### ビルドの仕組み

1. `./gradlew jekyllBuild` が `scripts/build.sh` を呼び出す
2. `scripts/build.sh` が `contents/blog/` の記事を `ai/_posts/` にコピー
3. `bundle install` → `jekyll build` を実行
4. 生成物は `ai/_site/` に出力される

---

## 🚀 CI/CD

`main` ブランチへの push ごとに GitHub Actions が自動でビルド・デプロイします。
ワークフローの詳細は `.github/workflows/deploy.yml` を参照してください。

---

## 📁 リポジトリ構成

```
ifrku-website/
├── contents/                    # ✏️ 人間が編集するコンテンツ（記事・固定ページ）
│   ├── blog/                    #   ブログ記事（YYYY-MM-DD-title.md）
│   └── about.md                 #   サイト紹介ページ
├── ai/                          # 🤖 AIが管理するJekyllテンプレート等
│   ├── _config.yml              #   Jekyll設定
│   ├── _layouts/                #   HTMLレイアウト
│   ├── _plugins/                #   カスタムプラグイン
│   ├── assets/                  #   CSS・画像
│   ├── index.html               #   トップページ
│   └── Gemfile                  #   Ruby依存関係
├── scripts/
│   └── build.sh                 # ビルドシェルスクリプト（Gradleから呼び出される）
├── build.gradle.kts             # Gradleビルドスクリプト
├── .github/
│   ├── copilot-instructions.md  # AIへのコーディング指示
│   └── workflows/deploy.yml     # 自動デプロイワークフロー
└── gradlew / gradlew.bat        # Gradleラッパー
```
