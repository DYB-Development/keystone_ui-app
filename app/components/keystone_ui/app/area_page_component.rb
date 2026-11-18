# frozen_string_literal: true

require "keystone_ui/navigation_order"

module KeystoneUi
  module App
    class AreaPageComponent < ViewComponent::Base
      Group = Struct.new(:label, :rows, keyword_init: true)

      def initialize(area_name:)
        @area_name = area_name
      end

      def groups
        area_groups.map do |group, pages|
          Group.new(label: group.label, rows: (pages - [ opened_page ]).map { |page| { label: page.label, href: page.href } })
        end.reject { |group| group.rows.empty? }
      end

      private

      def area_groups
        @area_groups ||= KeystoneUi::NavigationOrder.new(saved_order).arrange(permitted_groups).select { |group, _pages| area.groups.include?(group.label) }
      end

      def opened_page
        pages = area_groups.flat_map(&:last)
        pages.find { |page| page.key == area.opens } || pages.first
      end

      def area
        @area ||= KeystoneUi::App.configuration.app_areas.find { |declared| declared.name == @area_name } ||
          raise(ArgumentError, %(No app area is declared with the name "#{@area_name}".))
      end

      def saved_order
        value = KeystoneUi.configuration.supplied_preference(helpers, :navigation)&.dig(:value)
        value.is_a?(Hash) && value["order"].is_a?(Array) ? value["order"] : []
      end

      def permitted_groups
        KeystoneUi.configuration.navigation_groups
          .map { |group| [ group, group.tabs_permitted_for(helpers) ] }
          .reject { |_group, pages| pages.empty? }
      end
    end
  end
end
