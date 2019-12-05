# frozen_string_literal: true

module SimpleModelView
  class ActionViewHelperBuilder
    include SimpleModelView::TemplateHelpers

    def initialize(template)
      @template = template
    end

    attr_reader :template

    def resource_table(model, *args)
      builder = SimpleModelView::ResourceTableBuilder.new template, model, *args

      template.content_tag :table, nil, SimpleModelView.collection_table_html do
        template.content_tag :tbody do
          yield builder
        end
      end
    end

    def collection_table(collection, *args)
      builder = SimpleModelView::CollectionTableBuilder.new template, collection, *args

      template.content_tag :table, nil, SimpleModelView.collection_table_html do
        block_concat do
          template.content_tag :thead do
            template.content_tag :tr do
              columns_builder = builder.columns_builder
              yield columns_builder
            end
          end
        end
        block_concat do
          template.content_tag :tbody do
            collection.each do |el|
              block_concat do
                template.content_tag :tr do
                  row_builder = builder.row_builder_for el
                  yield row_builder
                end
              end
            end
          end
        end
      end
    end
  end
end
