// build.gradle.kts — ifrku-website
//
// このファイルはGradleのビルドスクリプトです。
// サイトのコンパイル処理は scripts/build.sh に委譲しており、
// GradleはそのシェルスクリプトをBashで起動するだけです。
//
// ディレクトリ構造:
//   contents/         — 人間が編集するコンテンツ（ブログ記事・固定ページ）
//   ai/site/          — JekyllテンプレートやCSSなどAIが管理するファイル群
//   ai/site/_site/    — Jekyllビルドの出力（コミット不要）
//   scripts/          — ビルドシェルスクリプト

// baseプラグインを適用してGradleの標準ライフサイクル（assemble, clean等）を有効化
plugins {
    base
}

// メインビルドタスク:
//   1. contents/blog/ の記事を ai/site/_posts/ にコピー
//   2. bundle install & jekyll build を実行
//   → 詳細は scripts/build.sh を参照
tasks.register<Exec>("jekyllBuild") {
    description = "scripts/build.sh 経由で Jekyll サイトをビルドします。"
    group = "jekyll"
    commandLine("bash", "scripts/build.sh")
}

// ローカル開発用タスク: Jekyll のライブリロードサーバーを起動します
tasks.register<Exec>("jekyllServe") {
    description = "scripts/build.sh serve 経由で Jekyll 開発サーバーを起動します。"
    group = "jekyll"
    commandLine("bash", "scripts/build.sh", "serve")
}

// Jekyllのビルド生成物を削除するタスク
tasks.register<Delete>("cleanSite") {
    description = "Jekyll の生成物 (ai/site/_site/) とコピーされたコンテンツを削除します。"
    group = "jekyll"
    // ビルド生成物
    delete("ai/site/_site")
    // スクリプトによってコピーされるファイル（再ビルド時に再生成される）
    delete("ai/site/_posts")
    delete("ai/site/about.md")
}

// Gradle標準ライフサイクルへの組み込み
// assemble（パッケージング）は jekyllBuild に依存させる
tasks.named("assemble") { dependsOn("jekyllBuild") }
// clean は cleanSite に依存させる
tasks.named("clean")    { dependsOn("cleanSite") }
