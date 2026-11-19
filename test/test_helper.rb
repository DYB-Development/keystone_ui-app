# frozen_string_literal: true

ENV["RAILS_ENV"] = "test"

require_relative "dummy/config/environment"
require "rails/test_help"
require "erb"

migration = Rails.root.join("../../lib/generators/keystone_ui/app/install/templates/create_keystone_ui_app_area_choices.rb.erb")
migration_version = "[#{ActiveRecord::Migration.current_version}]"
eval(ERB.new(File.read(migration)).result(binding))
ActiveRecord::Migration.verbose = false
CreateKeystoneUiAppAreaChoices.migrate(:up)

Rails.application.config.action_dispatch.show_exceptions = :none
