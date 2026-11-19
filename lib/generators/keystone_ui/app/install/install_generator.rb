# frozen_string_literal: true

require "rails/generators"
require "rails/generators/active_record"

module KeystoneUi
  module App
    module Generators
      class InstallGenerator < Rails::Generators::Base
        include ActiveRecord::Generators::Migration

        source_root File.expand_path("templates", __dir__)

        desc "Installs KeystoneUi::App: copies the migration for the table that keeps each account's choice of which areas are on."

        def copy_migration
          migration_template "create_keystone_ui_app_area_choices.rb.erb", "db/migrate/create_keystone_ui_app_area_choices.rb"
        end

        private

        def migration_version
          "[#{ActiveRecord::Migration.current_version}]"
        end
      end
    end
  end
end
