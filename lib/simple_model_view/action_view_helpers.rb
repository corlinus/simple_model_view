# frozen_string_literal: true

module SimpleModelView
  module ActionViewHelpers
    def resource_table_for(resource, *args, &block)
      SimpleModelView::ActionViewHelperBuilder.new(self).resource_table(resource, args, &block)
    end

    def resource_table(*args, &block)
      resource_table_for resource, *args, &block
    end

    def collection_table_for(collection, *args, &block)
      SimpleModelView::ActionViewHelperBuilder.new(self).collection_table(collection, *args, &block)
    end

    def collection_table(*args, &block)
      collection_table_for collection, *args, &block
    end
  end
end

ActiveSupport.on_load(:action_view) do
  include SimpleModelView::ActionViewHelpers
end
