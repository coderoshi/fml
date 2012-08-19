# encoding: utf-8
# FAQ Markup Language

require 'temple'
require 'fml/version'
require 'fml/parser'
require 'fml/wrap_filter'
require 'fml/details_filter'
require 'fml/markdown_filter'
require 'fml/engine'
require 'fml/template'

# module FAQML;end; require 'pp'; require 'temple'; %w{parser details_filter wrap_filter markdown_filter engine template}.each {|x| require "./lib/fml/#{x}"}
# puts Tilt.new('test/test0.fml').render
