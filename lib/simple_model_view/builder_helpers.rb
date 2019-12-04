# frozen_string_literal: true

module SimpleModelView # rubocop:disable
  module BuilderHelpers
    def format(value, type, **options)
      return if value.nil?

      formatter.new.call value, type, options
    end

    private

    def add_type_specific_class(value, type)
      return if value.nil?

      case type
      when :boolean
        value.to_s

      when :date, :time
        if value.today?
          'today'
        elsif value.past?
          value.since(1.day).today? ? 'past yesterday' : 'past'
        else
          value.ago(1.day).today? ? 'future tomorrow' : 'future'
        end

      when :integer, :float
        if value.zero?
          'zero'
        elsif value.negative?
          'negative'
        else
          'positive'
        end
      end
    end

    def add_custom_class(value, classes)
      return if value.nil?

      classes.select do |_k, v|
        if v.is_a?(Symbol)
          value.public_send(v)
        elsif v.respond_to?(:call)
          v.call(value)
        end
      end.keys.join(' ')
    end

    def autodetect_value_type(value)
      case value
      when Float
        :float
      when Integer
        :integer
      when BigDecimal
        :big_decimal
      when Time, DateTime, ActiveSupport::TimeWithZone
        :time
      when Date
        :date
      when TrueClass, FalseClass
        :boolean
      when String, Symbol
        :string
      else
        :object
      end
    end

    def prepare_render_data(attr_name:, options:)
      value = object.public_send(attr_name)

      collection = options[:collection]
      collection = value.class < Enumerable if collection.nil?

      value_type = :id if attr_name.to_s == 'id'
      value_type ||= options[:as]
      value_type ||= autodetect_value_type(value)

      wrapper_html = options[:wrapper_html] || {}
      custom_class = options[:custom_class] || {}

      classes = [*wrapper_html[:class]]
      classes.push(collection ? :collection : value_type)
      classes.push(add_type_specific_class(value, value_type)) if options[:type_specific_class]
      classes.push(add_custom_class(value, custom_class)) unless custom_class.empty?
      classes.compact!
      wrapper_html[:class] = classes

      {
        value: value,
        value_type: value_type,
        collection: collection,
        wrapper_html: wrapper_html,
      }
    end

    def render_value(data, **options, &block)
      if data[:collection]
        render_collection data[:value] do |el|
          type = autodetect_value_type(el)
          format_value_or_block el, type, options, &block
        end
      else
        format_value_or_block data[:value], data[:value_type], options, &block
      end
    end

    def format_value_or_block(value, type, **options, &block)
      return yield value if block
      return blank_span if value.nil?

      format value, type, **options
    end

    def render_collection(collection)
      template.content_tag :ul do
        collection.each do |el|
          template.concat(template.content_tag(:li, (yield el)))
        end
      end
    end
  end
end
