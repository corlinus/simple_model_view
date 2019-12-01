# frozen_string_literal: true

module SimpleModelView
  class CollectionTableRowBuilder
    include SimpleModelView::TemplateHelpers
    include SimpleModelView::BuilderHelpers

    def initialize(template, object, *_args, formatter: SimpleModelView::ValueFormatter)
      @template = template
      @object = object
      @formatter = formatter
    end

    attr_reader :template, :formatter, :object

    def column(attr_name, **options, &block)
      render_data = prepare_render_data(attr_name: attr_name, options: options)

      render_column render_data[:wrapper_html] do
        render_value render_data, options, &block
      end
    end

    def actions(*_args)
      template.content_tag(:td, nil) do
        yield object if block_given?
      end
    end

    private

    def render_column(wrapper_html)
      template.content_tag(:td, nil, **merge_html_attrs(default_wrapper_html, wrapper_html)) do
        yield
      end
    end

    # TODO: gem configuration to be used
    def default_wrapper_html
      {}
    end
  end
end
