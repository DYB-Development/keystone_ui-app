# frozen_string_literal: true

require "keystone_ui/visible_navigation"

module KeystoneUi
  module App
    class CurrentSection
      def initialize(view)
        @view = view
      end

      def group
        KeystoneUi::VisibleNavigation.new(
          KeystoneUi.configuration.navigation_groups,
          view: @view,
          saved_order: [],
          current_tab: KeystoneUi.configuration.supplied_current_tab(@view)
        ).groups.find(&:active)
      end
    end
  end
end
