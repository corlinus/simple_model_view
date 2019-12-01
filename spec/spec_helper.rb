# frozen_string_literal: true

require 'bundler/setup'
require 'byebug'
require 'simple_model_view'
require 'active_support/values/time_zone'
require 'active_support/time_with_zone'

require 'active_support'
require 'action_view'
require 'action_controller'

# for rspec-rails
module Rails
  module VERSION
    include ActionPack::VERSION
  end
end

require 'rails/version'
require 'rspec/rails'

I18n.load_path << Dir[File.expand_path('spec/support') + '/*.yml']
I18n.default_locale = :en

TestModel = Struct.new(:name)

TestObject = Struct.new(
  :class,
  :name,
  :id,
  :config,
  :integer_val,
  :float_val,
  :boolean_val,
  :none,
  :created_at,
  :collection_val,
  :nil_val,
  :date_past,
  :date_future,
  :date_today,
  :time_now
)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include RSpec::Rails::HelperExampleGroup, type: :helper

  if config.files_to_run.size < 3
    config.default_formatter = 'documentation'
  end
end
