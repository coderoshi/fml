# FAQ Markup Language
# require 'rubygems'
require 'redcarpet'

class FML
  def initialize(data)
    @data = data
  end

  def to_html(attrs={})
    linked_question = attrs[:linked_question] || true

    faqs, current = [], :q
    @data.split(/\n/m).each do |line|
      # start an answer block
      if line =~ /^===\s*$/
        raise "Cannot begin an answer without a question title" if current != :q
        current = :a
        next
      end

      # start a new question block
      if line =~ /^---/
        line = line.sub(/^#/, '').strip
        faqs << {:q => "", :a => "", :t => ""}
        current = :t
        next
      end

      faqs.last[current] += line

      current = :q if current == :t && line.strip != ''
    end

    renderer = Redcarpet::Render::HTML.new
    extensions = {fenced_code_blocks: true}
    redcarpet = Redcarpet::Markdown.new(renderer, extensions)

    buffer = ""
    for faq in faqs
      next if faq[:t] == ''
      buffer += "<section class=\"qna\">\n"
      if linked_question
        buffer += "<h1><a href=\"#\">#{faq[:t].to_s.strip}</a></h1>\n"
      else
        buffer += "<h1>#{faq[:t].to_s.strip}</h1>\n"
      end
      buffer += "<div class=\"qna\">"
      buffer += "<div class=\"question\">"
      buffer += redcarpet.render(faq[:q].to_s)
      buffer += "</div>"
      buffer += "<div class=\"answer\">"
      buffer += redcarpet.render(faq[:a].to_s)
      buffer += "</div>"
      buffer += "</div>"
      buffer += "</section>\n"
    end
    return buffer
  end
end
