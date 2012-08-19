class FAQML::Engine < Temple::Engine

  set_default_options :pretty => false,
                      :sort_attrs => true,
                      :attr_wrapper => '"',
                      :attr_delimiter => {'class' => ' '},
                      :remove_empty_attrs => true,
                      :generator => Temple::Generators::ArrayBuffer
                      # :default_tag => 'div'

  use FAQML::Parser, :strict

  # TODO: replace inline generation with a markdown filter
  # use FAQML::MarkdownFilter
  use FAQML::WrapFilter
  use FAQML::DetailsFilter

  html :AttributeMerger, :attr_delimiter
  html :AttributeSorter, :sort_attrs
  html :AttributeRemover, :remove_empty_attrs
  html :Pretty, :format, :attr_wrapper, :pretty, :indent

  filter :Escapable, :use_html_safe, :disable_escape
  filter :MultiFlattener
  # filter :StaticMerger
  # filter :DynamicInliner

  # generator :ArrayBuffer, :buffer

  use(:Optimizer) { (options[:streaming] ? Temple::Filters::StaticMerger : Temple::Filters::DynamicInliner).new }
  use(:Generator) { options[:generator].new(options) }
end
