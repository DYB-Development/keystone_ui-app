# frozen_string_literal: true

require "keystone_ui/visible_navigation"
require "keystone_ui/app/person_groups"

module KeystoneUi
  module App
    class CurrentSection
      def initialize(view)
        @view = view
      end

      def group
        KeystoneUi::VisibleNavigation.new(
          KeystoneUi::App::PersonGroups.for(@view).groups,
          view: @view,
          saved_order: [],
          current_tab: KeystoneUi.configuration.supplied_current_tab(@view)
        ).groups.find { |group| group.active && !group.standalone }
      end
    end
  end
end
