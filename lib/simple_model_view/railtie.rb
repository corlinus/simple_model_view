# frozen_string_literal: true

require 'rails/railtie'

module SimpleModelView
  class Railtie < Rails::Railtie
    config.eager_load_namespaces << SimpleModelView
  end
end
