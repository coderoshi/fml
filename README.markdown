# FML

The FAQ Markup Language. It's pretty simple. The gem is called `faqml`, so first install it.

```ruby
require 'rubygems'
require 'faqml'
data = File.readlines('mypage.fml').join()
puts FML.new(data).to_html
```

Your markup in `mypage.fml` should be valid markdown. The only difference is, that QnA blocks are started by three dashes (`---`), and questions and answers are seperated by three equals (`===`). The first line of the question block will be the QnA's title. That's all.

This FML

```fml
---
What kind of Bear is Best?
I hear there are basically two school of thought.
===
False. *Blackbear*.

---
Do Bears eat Beats?
===
Of course.
```

Produces this HTML

```html
<section class="qna">
  <h1><a href="#">What kind of Bear is Best?</a></h1>
  <div class="qna">
    <div class="question">
      <p>I hear there are basically two school of thought.</p>
    </div>
    <div class="answer">
      <p>False. <em>Blackbear</em>.</p>
    </div>
  </div>
</section>
<section class="qna">
  <h1><a href="#">Do Bears eat Beats?</a></h1>
  <div class="qna">
    <div class="answer">
      <p>Of course.</p>
    </div>
  </div>
</section>
```
