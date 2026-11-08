# frozen_string_literal: true

KeystoneUi::App::Engine.routes.draw do
  get "hotwire/ios/path_configuration", to: "keystone_ui/app/path_configurations#ios"
end
