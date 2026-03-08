# frozen_string_literal: true

# _plugins/character_block.rb
#
# Converts character dialogue shorthand into rich HTML speech bubbles.
#
# Usage in Markdown:
#   zundamon: ハローなのだ
#
# Supported characters can be extended by adding entries to CHARACTERS below.

module Jekyll
  module CharacterBlock
    CHARACTERS = {
      "zundamon" => {
        name: "ずんだもん",
        css_class: "zundamon",
        color: "#4caf50",
      },
    }.freeze

    # Match lines of the form "character_key: dialogue text"
    # The key must be at the start of the line (no leading whitespace).
    PATTERN = /^(#{Regexp.union(CHARACTERS.keys)}):[ \t]+(.+)$/

    def self.process(content)
      content.gsub(PATTERN) do
        char_key = Regexp.last_match(1)
        text = Regexp.last_match(2).strip
        char = CHARACTERS[char_key]
        img_src = "/assets/images/characters/#{char_key}.png"

        # Return a raw HTML block (surrounded by blank lines so Kramdown
        # treats it as a block element and does not wrap it in <p>).
        "\n" \
        "<div class=\"character-block character-#{char[:css_class]}\">\n" \
        "  <div class=\"character-avatar\">\n" \
        "    <img src=\"#{img_src}\" alt=\"#{char[:name]}\" " \
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

Jekyll::Hooks.register [:pages, :posts, :documents], :pre_render do |doc|
  doc.content = Jekyll::CharacterBlock.process(doc.content)
end
