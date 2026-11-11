# frozen_string_literal: true

require "keystone_ui/visible_navigation"

module KeystoneUi
  module App
    class MorePageComponent < ViewComponent::Base
      Group = Struct.new(:label, :rows, keyword_init: true)

      def groups
        visible_groups.map do |group|
          Group.new(label: group.label, rows: group.tabs.map { |page| { label: page.label, href: page.href } })
        end
      end

      private

      def visible_groups
        KeystoneUi::VisibleNavigation.new(
          KeystoneUi.configuration.navigation_groups,
          view: helpers,
          saved_order: saved_order,
          current_tab: nil
        ).groups
      end

      def saved_order
        value = KeystoneUi.configuration.supplied_preference(helpers, :navigation)&.dig(:value)
        value.is_a?(Hash) && value["order"].is_a?(Array) ? value["order"] : []
      end
    end
  end
end
