class FAQML::DetailsFilter < Temple::Filter
  def initialize(options = {})
    @options = options
  end

  def call(exp)
    compile(exp)
  end

  def on_fml_qna(question, answer=nil)
    answer_sexp = !answer.nil? && answer.length >= 4 ? build_fml_details('answer', answer[2], answer[3]) : nil
    question_sexp = build_fml_details('question', question[2], question[3])
    question_sexp.last << answer_sexp unless answer_sexp.nil?
    [:html, :tag, 'section', [:html, :attrs, [:html, :attr, 'class', [:static, 'qna']]],
      question_sexp
    ]
  end

  private

  def build_fml_details(class_name, summary, details)
    sexp = [:html, :tag, 'details',
      [:html, :attrs,
        [:html, :attr, 'class', [:static, class_name]]],
      [:multi]]
    if !summary.last.first.nil? && summary.last.first != ''
      sexp.last << [:html, :tag, 'summary', [:multi], [:static, summary.last.first]]
    end
    if details.length > 0
      sexp.last << [:html, :tag, 'div', [:multi], [:multi, *details.last]]
    end
    sexp
  end
end
