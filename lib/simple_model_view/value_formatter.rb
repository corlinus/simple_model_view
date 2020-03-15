# frozen_string_literal: true

module SimpleModelView
  class ValueFormatter
    attr_reader :value, :options

    def call(value, type, options)
      @value = value
      @options = options
      public_send "format_#{type}"
    end

    def format_id
      value.to_s
    end

    def format_boolean
      I18n.t "simple_model_view.formats.boolean.#{value}"
    end

    def format_date
      case options[:format]
      when Symbol
        I18n.l value, format: options[:format]

      when String
        value.strftime options[:format]

      else
        I18n.l value
      end
    end

    alias_method :format_time, :format_date

    def format_integer
      value_format 'integer'
    end

    def format_float
      value_format 'float'
    end

    def format_md
      raise NotImplementedError, '`md` is not implemented yet'
    end

    def format_inspect
      value.inspect
    end

    def format_object
      value.to_s
    end

    def format_string
      value.to_s
    end

    private

    def value_format(type)
      format_string = fetch_format_string options[:format], "simple_model_view.formats.#{type}"
      format_string ? format_string % value : value.to_s
    end

    def fetch_format_string(format, path)
      return unless format
      return I18n.t(format, scope: path) if format.is_a?(Symbol)
      format.to_s
    end
  end
end
