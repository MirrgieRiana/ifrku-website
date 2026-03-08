# frozen_string_literal: true

# _plugins/character_block.rb
#
# キャラクターセリフブロックをHTMLの吹き出しに変換するJekyllプラグインです。
#
# 【使い方】Markdown内で以下のように書くと吹き出しになります:
#   zundamon: ハローなのだ
#
# 新しいキャラクターを追加するには CHARACTERS ハッシュにエントリを追加してください。
# キャラクター画像は assets/images/characters/<キー名>.png に配置します
# （画像が存在しない場合は絵文字のプレースホルダーで代替されます）。

module Jekyll
  module CharacterBlock
    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    # 対応キャラクターの定義
    # キーはMarkdown内で使用するキーワードです（例: zundamon: テキスト）
    # ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    CHARACTERS = {
      "zundamon" => {
        name: "ずんだもん",       # 吹き出しに表示されるキャラクター名
        css_class: "zundamon",    # HTMLに付与されるCSSクラス名
        color: "#4caf50",         # テーマカラー（CSSで使用）
      },
    }.freeze

    # 行頭から始まる「キーワード: セリフ」という形式にマッチする正規表現
    # 先頭の空白は許容しない（コードブロック内での誤変換を防ぐため）
    PATTERN = /^(#{Regexp.union(CHARACTERS.keys)}):[ \t]+(.+)$/

    # コンテンツ全体を走査してキャラクターブロックをHTMLに置換するメソッド
    def self.process(content)
      content.gsub(PATTERN) do
        char_key = Regexp.last_match(1)  # キャラクターのキー（例: "zundamon"）
        text = Regexp.last_match(2).strip  # セリフのテキスト
        char = CHARACTERS[char_key]
        # 画像パスはリポジトリの assets/images/characters/ 以下を参照
        img_src = "/assets/images/characters/#{char_key}.png"

        # HTMLブロックを生成して返す
        # 空行で囲むことでKramdownが<p>タグで囲まないようにする
        "\n" \
        "<div class=\"character-block character-#{char[:css_class]}\">\n" \
        "  <div class=\"character-avatar\">\n" \
        "    <img src=\"#{img_src}\" alt=\"#{char[:name]}\" " \
        # 画像が存在しない場合は no-image クラスを付けて絵文字フォールバックを表示
        "onerror=\"this.parentElement.classList.add('no-image')\">\n" \
        "  </div>\n" \
        "  <div class=\"speech-bubble\">\n" \
        "    <div class=\"speech-bubble__name\">#{char[:name]}</div>\n" \
        "    <p class=\"speech-bubble__text\">#{CGI.escapeHTML(text)}</p>\n" \
        "  </div>\n" \
        "</div>\n"
      end
    end
  end
end

require "cgi"

# Jekyllのpre_renderフックに登録する
# ページ・投稿・ドキュメントすべてのレンダリング前に実行される
Jekyll::Hooks.register [:pages, :posts, :documents], :pre_render do |doc|
  doc.content = Jekyll::CharacterBlock.process(doc.content)
end

