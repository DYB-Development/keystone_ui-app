# frozen_string_literal: true

require "keystone_ui/visible_navigation"

module KeystoneUi
  module App
    class MorePageComponent < ViewComponent::Base
      Group = Struct.new(:label, :rows, keyword_init: true)
      FRAME = "keystone-ui-app-more-page-list"

      def find
        helpers.params[:find].to_s.strip
      end

      def groups
        visible_groups.filter_map do |group|
          label = group.label unless group.standalone
          pages = found(label) ? group.tabs : group.tabs.select { |page| found(page.label) }
          Group.new(label: label, rows: pages.map { |page| { label: page.label, href: page.href } }) if pages.any?
        end
      end

      private

      def found(text)
        find.empty? || text.to_s.downcase.include?(find.downcase)
      end

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
