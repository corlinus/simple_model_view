# frozen_string_literal: true

module SimpleModelView
  class CollectionTableHeaderBuilder
    include SimpleModelView::TemplateHelpers

    attr_reader :template, :collection

    def initialize(template, collection)
      @template = template
      @collection = collection
    end

    def column(attr_name, *_args, **options)
      title = options[:title]
      title ||= if collection_class
                  collection_class.human_attribute_name attr_name
                else
                  attr_name.to_s.humanize
                end
      template.content_tag :th, title, options[:header_html] || {}
    end

    def actions(*_args, **options)
      th_html_attributes = merge_html_attrs default_header_html, options[:header_html].to_h
      template.content_tag :th, options[:title].to_s, **th_html_attributes
    end

    private

    def collection_class
      return @collection_class unless @collection_class.nil?

      @collection_class =
        if defined?(ActiveRecord::Relation) && collection.class < ActiveRecord::Relation
          collection.new.class
        else
          false
        end
    end

    # TODO: gem configuration to be used
    def default_header_html
      {}
    end
  end
end
