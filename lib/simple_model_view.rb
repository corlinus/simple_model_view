# frozen_string_literal: true

require 'action_view'
require 'simple_model_view/version'
require 'simple_model_view/action_view_helpers'

module SimpleModelView
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :ActionViewHelperBuilder
    autoload :TemplateHelpers
    autoload :ValueFormatter
    autoload :BuilderHelpers
    autoload :ResourceTableBuilder
    autoload :CollectionTableHeaderBuilder
    autoload :CollectionTableRowBuilder
    autoload :CollectionTableBuilder
  end
end

require 'simple_model_view/railtie' if defined?(Rails)
