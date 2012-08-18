require 'redcarpet'

# Transforms FML into a Temple expression
# @api private
class FAQML::Parser
  include Temple::Mixins::Options

  set_default_options :tabsize => 4,
                      :encoding => 'utf-8'

  class SyntaxError < StandardError
    attr_reader :error, :file, :line, :lineno, :column

    def initialize(error, file, line, lineno, column)
      @error = error
      @file = file || '(__TEMPLATE__)'
      @line = line.to_s
      @lineno = lineno
      @column = column
    end

    def to_s
      line = @line.strip
      column = @column + line.size - @line.size
      %{#{error}
#{file}, Line #{lineno}
  #{line}
  #{' ' * column}^
}
    end
  end

  def initialize(options = {})
    super

    renderer = Redcarpet::Render::HTML.new
    extensions = {fenced_code_blocks: true}
    @markdown = Redcarpet::Markdown.new(renderer, extensions)

    @tab = ' ' * @options[:tabsize]
  end

  # Compile string to Temple expression
  #
  # @param [String] str FML code
  # @return [Array] Temple expression representing the code]]
  def call(str)
    # Set string encoding if option is set
    if options[:encoding] && str.respond_to?(:encoding)
      old_enc = str.encoding
      str = str.dup if str.frozen?
      str.force_encoding(options[:encoding])
      # Fall back to old encoding if new encoding is invalid
      str.force_encoding(old_enc) unless str.valid_encoding?
    end

    result = [:multi]
    reset(str.split(/\r?\n/), result)

    parse_line while next_line

    reset
    result
  end

  private

  # TODO: the markdown rendering should be a filter... that way
  # you could have different kinds of FML markups

  # TODO: rewrite this to have a sort of wrapping filter... have this just output:
  # [:question, [:summary, [text]], [:data, [line, line...]]]
  # [:answer,   [:summary, [text]], [:data, [line, line...]]]

  def parse_line
    # start an answer block
    if @line =~ /^a(nswer)?(\s*)\:\s*(.*?)$/i
      asummary = @line.sub(/^a(nswer)?(\s*)\:(\s*)/i, '')
      syntax_error!("Cannot begin an answer without a question") if @current != :q
      @current = :a

      @stacks.last.last << [:html, :tag, 'details', [:html, :attrs, [:html, :attr, 'class', [:static, 'answer']]], [:multi]]
      @stacks.last.last.last.last << [:html, :tag, 'summary', [:multi], [:static, asummary]]
      @stacks.last.last.last.last << [:html, :tag, 'div', [:multi], [:multi]]

    elsif @line =~ /^q(uestion)?(\s*)\:\s*(.*?)$/i
      qsummary = @line.sub(/^q(uestion)?(\s*)\:(\s*)/i, '')
      @current = :q

      @stacks << [:html, :tag, 'section', [:html, :attrs, [:html, :attr, 'class', [:static, 'qna']]],[:multi]]
      @stacks.last.last << [:html, :tag, 'details', [:html, :attrs, [:html, :attr, 'class', [:static, 'question']]], [:multi]]
      @stacks.last.last.last.last << [:html, :tag, 'summary', [:multi], [:static, qsummary]]
      @stacks.last.last.last.last << [:html, :tag, 'div', [:multi], [:multi]]

    else
      indent = get_indent(@line)
      if @base_indent == 0
        @base_indent = indent
        @strip_exp = %r"^\s{#{@base_indent}}"
      end

      if indent >= 1
        # strip off base_indent from @line
        @stacks.last.last.last.last.last.last << [:static, @line.sub("\t", @tab).sub(@strip_exp, '')]
        @stacks.last.last.last.last.last.last << [:newline]
      else
        # done with the indented block
        @base_indent = 0
      end

      @current = :q if @line.strip != ''
    end
  end

  def reset(lines = nil, stacks = nil)
    @stacks = stacks
    @base_indent = 0
    @lineno = 0
    @lines = lines
    @line = @orig_line = nil
    @current = nil
  end

  def next_line
    if @lines.empty?
      @orig_line = @line = nil
    else
      @orig_line = @lines.shift
      @lineno += 1
      @line = @orig_line.dup
    end
  end

  def get_indent(line)
    # Figure out the indentation. ugly/slow/ ripped from Slim
    line[/\A[ \t]*/].sub("\t", @tab).size
  end

  # Helper for raising exceptions
  def syntax_error!(message, args = {})
    args[:orig_line] ||= @orig_line
    args[:line] ||= @line
    args[:lineno] ||= @lineno
    args[:column] ||= args[:orig_line] && args[:line] ? args[:orig_line].size - args[:line].size : 0
    raise SyntaxError.new(message, options[:file],
                          args[:orig_line], args[:lineno], args[:column])
  end
end