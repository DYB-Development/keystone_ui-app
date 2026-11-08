# frozen_string_literal: true

require "keystone_ui/app/current_section"

module KeystoneUi
  module App
    class BottomTabsComponent < ViewComponent::Base
      def render?
        tabs.any?
      end

      def tabs
        @tabs ||= KeystoneUi::App.configuration.bottom_tabs.select { |tab| tab.permitted.call(helpers) }
      end

      def active?(tab)
        section.present? && tab.section == section.label
      end

      def section
        @section ||= KeystoneUi::App::CurrentSection.new(helpers).group
      end
    end
  end
end
