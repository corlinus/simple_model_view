# frozen_string_literal: true

module SimpleModelView
  module TemplateHelpers
    def block_concat
      template.concat yield
    end

    def blank_span
      template.content_tag :span, I18n.t('simple_model_view.empty'), class: :empty
    end

    def merge_html_attrs(default, input)
      result = default.transform_keys(&:to_sym)
      input = input.transform_keys(&:to_sym)

      if result[:data].is_a?(Hash) && input[:data].is_a?(Hash)
        input[:data] = result[:data].merge(input[:data])
      end

      if result[:class] && input[:class]
        input[:class] = [*default[:class], *input[:class]]
      end

      result.merge! input
      result.compact!
      result
    end
  end
end
