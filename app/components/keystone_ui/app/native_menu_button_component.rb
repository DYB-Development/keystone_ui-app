# frozen_string_literal: true

require "keystone_ui/app/current_section"

module KeystoneUi
  module App
    class NativeMenuButtonComponent < ViewComponent::Base
      CONTROLLER = "bridge--menu-button"

      def call
        tag.div(data: { controller: CONTROLLER, "#{CONTROLLER}-menu-value": menu.to_json })
      end

      def menu
        { title: section&.label, items: tabs.map { |tab| { title: tab.label, path: tab.href } } }
      end

      def tabs
        section ? section.tabs : []
      end

      def section
        @section ||= KeystoneUi::App::CurrentSection.new(helpers).group
      end
    end
  end
end
