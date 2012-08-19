# FML

The FAQ Markup Language. It's pretty simple. The gem is called `faqml`, so first install it. Then just access it through Tilt.

```ruby
require 'rubygems'
require 'faqml'
require 'tilt'
puts Tilt.new('mypage.fml').render
```

Your markup in `mypage.fml` should be valid markdown. The only difference is, that QnA blocks are started by the keyword "question:", or "Q:", and answers being with "answer:" or "A:". If there is any text on the line after the question or answer keywords, it will be that section's summary (neither are required). All remaining indented text consitute the body of the question of answer.

This FML

```fml
question: What kind of Bear is Best?
  I hear there are basically two school of thought.
answer:
  False. *Blackbear*.

Q: Do Bears eat Beats?
A: Of course.
```

Produces this HTML

```html
<section class="qna">
  <details class="question" open>
    <summary>What kind of Bear is Best?</summary>
    <div>I hear there are basically two school of thought</div>
    <details class="answer" open>
      <div>False. *Blackbear*</div>
    </details>
  </details>
</section>
<section class="qna">
  <details class="question" open>
    <summary>Do Bears eat Beats?</summary>
    <details class="answer" open>
      <summary>Of course.</summary>
    </details>
  </details>
</section>
```
