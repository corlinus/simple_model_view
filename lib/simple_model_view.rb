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

  @collection_table_html = {}
  @collection_header_html = {}
  @collection_wrapper_html = {}
  @resource_table_html = {}
  @resource_wrapper_html = {}
  @resource_label_html = {}
  @resource_value_html = {}

  @formatter = SimpleModelView::ValueFormatter

  class << self
    attr_accessor :collection_table_html
    attr_accessor :collection_header_html
    attr_accessor :collection_wrapper_html
    attr_accessor :resource_table_html
    attr_accessor :resource_wrapper_html
    attr_accessor :resource_label_html
    attr_accessor :resource_value_html

    attr_accessor :formatter

    def setup
      yield self
    end
  end
end

require 'simple_model_view/railtie' if defined?(Rails)
