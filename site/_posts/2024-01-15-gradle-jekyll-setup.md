---
layout: post
title: "Gradle を使った Jekyll ビルドの仕組み"
date: 2024-01-15 12:00:00 +0900
tags: [技術, 開発, Gradle, Jekyll]
---

このブログは Jekyll + Gradle の構成で動いています。今回はそのビルドの仕組みについて説明します。

## なぜ Gradle なのか

zundamon: Gradle って Java のツールじゃないのだ？なんで Jekyll ブログに使うのだ？

よい質問です！Gradle は Java/Kotlin プロジェクト向けのイメージが強いですが、実はどんなビルドタスクにも使えるビルドツールです。

特徴として:

- **タスクの依存関係管理** — タスク A が完了してからタスク B を実行、などが簡単に書ける
- **インクリメンタルビルド** — 変更があったファイルだけ再ビルドする
- **豊富なプラグインエコシステム**
- **Kotlin DSL** でタイプセーフな設定ができる

## ビルド構成

`build.gradle.kts` に以下のタスクを定義しています:

```kotlin
tasks.register<Exec>("jekyllBuild") {
    commandLine("bundle", "exec", "jekyll", "build")
}
```

## デプロイ

GitHub Actions で `./gradlew jekyllBuild` を実行し、生成された `_site/` を GitHub Pages にデプロイしています。

zundamon: なるほどなのだ！シンプルで分かりやすいのだ！

## まとめ

Gradle は Jekyll サイトのビルドツールとしても十分に使えます。
特に将来的に Java/Kotlin コードが増えた場合でも、同じビルドシステムで管理できるのは大きなメリットです。
