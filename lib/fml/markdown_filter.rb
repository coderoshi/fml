require 'redcarpet'

class FAQML::MarkdownFilter < Temple::Filter
  def initialize(options = {})
    @options = options
    
    renderer = Redcarpet::Render::HTML.new
    extensions = {:fenced_code_blocks => true}
    @markdown = Redcarpet::Markdown.new(renderer, extensions)
  end

  def call(exp)
    compile(exp)
  end

  def on_fml_answer(summary, details)
    build_fml_type(:answer, summary, details)
  end

  def on_fml_question(summary, details)
    build_fml_type(:question, summary, details)
  end

  def build_fml_type(type, summary, details)
    [:fml, type,
      [:fml, :summary, [build_markdown(summary.last)]],
      [:fml, :details, [[:static, build_markdown(details.last)]]]
    ]
  end

  def build_markdown(lines)
    markdown_data = ""
    lines.each do |line|
      if line.is_a? String
        markdown_data += line
        next
      end
      case line.first
      when :static
      	markdown_data += line.last
      when :newline
      	markdown_data += "\n"
      end
    end
    markdown_data = @markdown.render(markdown_data)
  end
end
