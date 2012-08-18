module FAQML
  # Tilt template implementation for FAQML
  # @api public
  Template = Temple::Templates::Tilt(FAQML::Engine, :register_as => :fml)

  if Object.const_defined?(:Rails)
    # Rails template implementation for FAQML
    # @api public
    RailsTemplate = Temple::Templates::Rails(FAQML::Engine,
                                             :register_as => :fml,
                                             # Use rails-specific generator. This is necessary
                                             # to support block capturing and streaming.
                                             :generator => Temple::Generators::RailsOutputBuffer,
                                             # Rails takes care of the capturing by itself.
                                             :disable_capture => true,
                                             :streaming => Object.const_defined?(:Fiber))
  end
end