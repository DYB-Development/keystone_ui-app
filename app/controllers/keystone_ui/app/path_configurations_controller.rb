# frozen_string_literal: true

module KeystoneUi
  module App
    class PathConfigurationsController < ::ApplicationController
      MODAL_PATTERNS = [ "/new$", "/edit$" ].freeze
      IOS_RULES = [ { patterns: MODAL_PATTERNS, properties: { context: "modal" } } ].freeze
      ANDROID_RULES = [
        { patterns: [ ".*" ], properties: { context: "default", uri: "hotwire://fragment/web", fallback_uri: "hotwire://fragment/web", pull_to_refresh_enabled: true } },
        { patterns: MODAL_PATTERNS, properties: { context: "modal", pull_to_refresh_enabled: false } }
      ].freeze

      def ios
        render json: { settings: { tabs: ios_tabs }, rules: IOS_RULES + app_rules }
      end

      def android
        render json: { settings: { tabs: android_tabs.to_json }, rules: ANDROID_RULES + app_rules }
      end

      private

      def ios_tabs
        permitted_tabs.map { |tab| { title: tab.label, path: tab.href_for(view), ios_system_image_name: tab.ios_system_image } }
      end

      def android_tabs
        permitted_tabs.map { |tab| { title: tab.label, path: tab.href_for(view), icon: tab.android_icon } }
      end

      def app_rules
        KeystoneUi::App.configuration.native_rules
      end

      def permitted_tabs
        KeystoneUi::App.configuration.bottom_tabs.select { |tab| tab.permitted.call(view) }
      end

      def view
        @view ||= view_context
      end
    end
  end
end
