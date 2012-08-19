# organizes the FAQs into a wrapped-block layout
class FAQML::WrapFilter < Temple::Filter

  class SexpError < StandardError
  end

  def initialize(options = {})
    @options = options
  end

  def call(exp)
    compile(exp)
  end

  def on_multi(*exps)
    result = [:multi]

    current_block = nil

    exps.each do |exp|
      exp = compile(exp)

      if exp.length > 2 && exp[0] == :fml
        case exp[1]
        when :question
          # compile the details
          # exp[3] = compile(exp[3])
          current_block = [:fml, :qna, exp]
          result << current_block
        when :answer
          raise SexpError, "Cannot create an answer without a question" if current_block.nil?
          result.last << exp
          current_block = nil
        else
          result << exp
        end
        next
      end

      result << exp
    end

    result
  end
end
