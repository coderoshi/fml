# FML

The FAQ Markup Language. It's pretty simple. The gem is called `faqml`, so first install it. Then just access it through Tilt.

```ruby
require 'rubygems'
require 'faqml'
require 'tilt'
puts Tilt.new('mypage.fml').render
```

Your markup in `mypage.fml` should be valid markdown. The only difference is, that QnA blocks are started by three dashes (`---`), and questions and answers are seperated by three equals (`===`). The first line of the question block will be the QnA's title. That's all.

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
  <details class="question">
    <summary>What kind of Bear is Best?</summary>
    <div>I hear there are basically two school of thought</div>
  </details>
  <details class="answer">
    <div>False. *Blackbear*</div>
  </details>
</section>
<section class="qna">
  <details class="question">
    <summary>Do Bears eat Beats?</summary>
  </details>
  <details class="answer">
    <summary>Of course.</summary>
  </details>
</section>
```
