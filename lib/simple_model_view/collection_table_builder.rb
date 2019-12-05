# frozen_string_literal: true

module SimpleModelView
  class CollectionTableBuilder
    include SimpleModelView::TemplateHelpers
    include SimpleModelView::BuilderHelpers

    def initialize(template, collection, *_args, formatter: SimpleModelView.formatter)
      @template = template
      @collection = collection
      @formatter = formatter
    end

    attr_reader :collection, :formatter

    def columns_builder
      CollectionTableHeaderBuilder.new template, collection
    end

    def row_builder_for(resource)
      CollectionTableRowBuilder.new template, resource, formatter: formatter
    end

    private

    attr_reader :template
  end
end
