Gem::Specification.new do |s|
  s.name        = 'faqml'
  s.version     = '0.1.1'
  s.date        = '2012-08-10'
  s.summary     = "FAQ Markup Language"
  s.description = "A Simple FAQ Markup Language, based on Markdown"
  s.authors     = ["Eric Redmond"]
  s.email       = 'eric@basho.com'
  s.files       = ["lib/faqml.rb"]
  s.homepage    = 'http://rubygems.org/gems/faqml'

  s.add_dependency('redcarpet', '>= 2.1.1')

  s.files       = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
end
