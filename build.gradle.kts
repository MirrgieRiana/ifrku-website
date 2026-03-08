// build.gradle.kts — ifrku-website
//
// このファイルはGradleのビルドスクリプトです。
// ウェブサイトのソースコードは site/ サブディレクトリに格納されており、
// Jekyll（Ruby製静的サイトジェネレーター）を使ってビルドします。
// 各タスクはすべて site/ ディレクトリを作業ディレクトリとして実行します。

// baseプラグインを適用してGradleの標準ライフサイクル（assemble, clean等）を有効化
plugins {
    base
}

// Rubyの依存パッケージ（gem）をBundlerでインストールするタスク
tasks.register<Exec>("bundleInstall") {
    description = "Bundlerで site/ の Ruby gem 依存関係をインストールします。"
    group = "jekyll"
    // site/ ディレクトリ内の Gemfile を参照してインストール
    workingDir("site")
    commandLine("bundle", "install")
}

// JekyllでWebサイトをビルドするタスク（site/_site/ に出力される）
tasks.register<Exec>("jekyllBuild") {
    description = "Jekyll で site/ をビルドし、site/_site/ に静的ファイルを生成します。"
    group = "jekyll"
    // gemインストールを先に完了させる
    dependsOn("bundleInstall")
    workingDir("site")
    commandLine("bundle", "exec", "jekyll", "build")
}

// ローカル開発用にJekyllサーバーを起動するタスク（ライブリロード対応）
tasks.register<Exec>("jekyllServe") {
    description = "Jekyll のローカルサーバーをライブリロード付きで起動します（開発用）。"
    group = "jekyll"
    dependsOn("bundleInstall")
    workingDir("site")
    commandLine("bundle", "exec", "jekyll", "serve", "--livereload")
}

// Jekyllのビルド生成物を削除するタスク
tasks.register<Delete>("cleanSite") {
    description = "Jekyll の生成物 (site/_site/) を削除します。"
    group = "jekyll"
    delete("site/_site")
}

// Gradle標準ライフサイクルへの組み込み
// assemble（パッケージング）は jekyllBuild に依存させる
tasks.named("assemble") { dependsOn("jekyllBuild") }
// clean は cleanSite に依存させる
tasks.named("clean")    { dependsOn("cleanSite") }
