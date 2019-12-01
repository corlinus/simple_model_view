# frozen_string_literal: true

module SimpleModelView
  class CollectionTableBuilder
    include SimpleModelView::TemplateHelpers
    include SimpleModelView::BuilderHelpers

    def initialize(template, collection, *_args)
      @template = template
      @collection = collection
    end

    attr_reader :template, :collection

    def columns_builder
      CollectionTableHeaderBuilder.new template, collection
    end

    def row_builder_for(resource)
      CollectionTableRowBuilder.new template, resource
    end
  end
end
