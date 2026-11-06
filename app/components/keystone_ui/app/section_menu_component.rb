# frozen_string_literal: true

require "keystone_ui/visible_navigation"

module KeystoneUi
  module App
    class SectionMenuComponent < ViewComponent::Base
      WRAPPER_CLASSES = "lg:hidden"

      def render?
        section.present?
      end

      def section
        @section ||= KeystoneUi::VisibleNavigation.new(
          KeystoneUi.configuration.navigation_groups,
          view: helpers,
          saved_order: [],
          current_tab: KeystoneUi.configuration.supplied_current_tab(helpers)
        ).groups.find(&:active)
      end
    end
  end
end
