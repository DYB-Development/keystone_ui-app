# frozen_string_literal: true

require "rails/engine"
require "keystone_ui/app/shell_check"

module KeystoneUi
  module App
    class Engine < ::Rails::Engine
      def self.check_shell
        configuration = KeystoneUi::App.configuration
        KeystoneUi::App::ShellCheck.new(
          bottom_tabs: configuration.bottom_tabs,
          native_rules: configuration.native_rules,
          sections: KeystoneUi.configuration.navigation_groups.map(&:label),
          app_areas: configuration.app_areas,
          more_page: configuration.more_page_tab
        ).call
      end

      initializer "keystone_ui_app.importmap", before: "importmap" do |app|
        app.config.importmap.paths << root.join("config/importmap.rb") if app.config.respond_to?(:importmap)
      end

      config.after_initialize do
        KeystoneUi::App::Engine.check_shell
      end
    end
  end
end
