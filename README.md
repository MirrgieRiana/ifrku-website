# ifrku-website

ifrku の公式ブログ。ソースは Markdown、ビルドツールは Gradle、Jekyll で静的サイトを生成し GitHub Pages で公開します。

## ローカル開発

```bash
# Gradle ラッパーを使ってビルド
./gradlew jekyllBuild

# ローカルサーバー起動（ライブリロード対応）
./gradlew jekyllServe
```

## キャラクターブロック

Markdown 内で以下のように書くとキャラクターの吹き出しになります。

```
zundamon: ハローなのだ
```

キャラクター画像は `assets/images/characters/` に PNG ファイルを配置してください。詳細は [assets/images/characters/README.md](assets/images/characters/README.md) を参照。

## ブログ記事の追加

`_posts/` ディレクトリに `YYYY-MM-DD-title.md` の形式でファイルを作成してください。

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