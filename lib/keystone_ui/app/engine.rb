# frozen_string_literal: true

require "rails/engine"

module KeystoneUi
  module App
    class Engine < ::Rails::Engine
      initializer "keystone_ui_app.importmap", before: "importmap" do |app|
        app.config.importmap.paths << root.join("config/importmap.rb") if app.config.respond_to?(:importmap)
      end
    end
  end
end
