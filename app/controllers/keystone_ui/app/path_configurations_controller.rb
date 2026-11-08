# frozen_string_literal: true

module KeystoneUi
  module App
    class PathConfigurationsController < ::ApplicationController
      def ios
        render json: { settings: { tabs: ios_tabs } }
      end

      private

      def ios_tabs
        permitted_tabs.map { |tab| { title: tab.label, path: tab.href_for(view), ios_system_image_name: tab.ios_system_image } }
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
