# frozen_string_literal: true

module SimpleModelView
  class ResourceTableBuilder
    include SimpleModelView::TemplateHelpers
    include SimpleModelView::BuilderHelpers

    def initialize(template, object, *_args, formatter: SimpleModelView::ValueFormatter)
      @template = template
      @object = object
      @formatter = formatter
    end

    attr_reader :formatter, :object

    # Renders row for given +attr_name+.
    #
    # === Arguments
    #
    # * +attr_name+ - Attribute to be rendered as a +Symbol+ or +String+.
    # * +title:+ - +String+ to use as attribute name in table.
    #   Using +human_attribute_name+ or if not given.
    # * +as:+ - Force attribute value type _(:boolean, :date, :time, :integer, :float, etc...)_.
    # * +collection:+ - If +true+ tryes to interpret value as a iterateble collection.
    # * +type_specific_class:+ - adds type specific classes to the wrapper <tr> tag.
    #   For numeric it would be `negative`, `zero`, `positieve`;
    #   For date and time it would be `past`, `future`, `yesterday`, etc;
    #   See Examples for more details.
    # * +custom_class:+ - +Hash+ with values as +Symbol+ or any +callable object+. symbol will be
    #   sent to the value as a method. Proc will be called and passed a value as an argument. If
    #   method or block retuns not +false+ or +nil+ hash key will be added as a class to the
    #   wrapper <tr> tag.
    # * +wrapper_html:+ - html attributes to add to wrapper <tr> tag.
    # * +label_html:+ - html attributes to add to attribute title <th> tag.
    # * +value_html:+ - html attributes to add to attribute value <td> tag.
    # * +**options+ - all other named arguments will be passed to the formatter.
    # * &block - if block given it will render inside value cell.
    #
    # === Examples
    #
    # TODO:
    #
    def row(attr_name, title: nil, **options, &block)
      title ||= if object.class.respond_to?(:human_attribute_name)
                  object.class.human_attribute_name attr_name
                else
                  attr_name.to_s.humanize
                end

      render_data = prepare_render_data(attr_name: attr_name, options: options)

      label_html = options[:label_html] || {}
      value_html = options[:value_html] || {}

      render_row title, render_data[:wrapper_html], label_html, value_html do
        render_value render_data, options, &block
      end
    end

    private

    attr_reader :template

    def render_row(title, wrapper_html, label_html, value_html)
      template.content_tag(:tr, **merge_html_attrs(default_wrapper_html, wrapper_html)) do
        template.concat template.content_tag(:th, title,
          **merge_html_attrs(default_label_html, label_html))

        block_concat do
          template.content_tag :td, yield, **merge_html_attrs(default_value_html, value_html)
        end
      end
    end

    # TODO: gem configuration to be used
    def default_wrapper_html
      {}
    end

    def default_label_html
      {}
    end

    def default_value_html
      {}
    end
  end
end
