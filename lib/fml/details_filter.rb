class FAQML::DetailsFilter < Temple::Filter
  def initialize(options = {})
    @options = options
  end

  def call(exp)
    compile(exp)
  end

  def on_fml_qna(question, answer=nil)
    answer_sexp = !answer.nil? && answer.length >= 4 ? build_fml_details('answer', true, answer[2], answer[3]) : nil
    question_sexp = build_fml_details('question', false, question[2], question[3])
    question_sexp.last << answer_sexp unless answer_sexp.nil?
    [:html, :tag, 'section', [:html, :attrs, [:html, :attr, 'class', [:static, 'qna']]],
      question_sexp
    ]
  end

  private

  def build_fml_details(class_name, open, summary, details)
    attrs = [:html, :attrs, [:html, :attr, 'class', [:static, class_name]] ]
    # open if marked as open, or has no summary
    attrs << [:html, :attr, 'open', [:static, 'open']] if open || !has_summary_text?(summary)

    sexp = [:html, :tag, 'details', attrs, [:multi]]
    sexp.last << [:html, :tag, 'summary', [:multi], [:static, summary.last.first]]
    sexp.last << [:html, :tag, 'div', [:multi], [:multi, *details.last]] if details.length > 0
    sexp
  end

  def has_summary_text?(summary)
    !summary.last.first.nil? && summary.last.first != ''
  end
end
