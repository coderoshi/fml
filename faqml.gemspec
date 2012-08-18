# -*- encoding: utf-8 -*-
require File.dirname(__FILE__) + '/lib/fml/version'
require 'date'

Gem::Specification.new do |s|
  s.name        = 'faqml'
  s.version     = FAQML::VERSION
  s.date        = Date.today.to_s
  s.summary     = "FAQ Markup Language"
  s.description = "A Simple FAQ Markup Language"
  s.authors     = ["Eric Redmond"]
  s.email       = 'eric@basho.com'
  s.homepage    = 'http://rubygems.org/gems/faqml'

  s.add_dependency('redcarpet', '>= 2.1.1')
  s.add_dependency('temple', '>= 0.4.0')
  s.add_dependency('tilt', '~> 1.3.3')

  s.files       = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
end
