# frozen_string_literal: true

require "keystone_ui/navigation_order"
require "keystone_ui/app/shell_check"

module KeystoneUi
  module App
    class BottomBar
      Tab = Struct.new(:label, :href, :icon, :ios_system_image, :android_icon, :sections, keyword_init: true)

      MORE_LABEL = "More"
      MOST_TABS = ShellCheck::MOST_BOTTOM_TABS

      def initialize(view)
        @view = view
      end

      def tabs
        shown = fixed_tabs + area_tabs
        full = shown.first(MOST_TABS)
        more_tab_needed?(full) ? shown.first(MOST_TABS - 1) + [ more_tab ] : full
      end

      private

      def fixed_tabs
        configuration.bottom_tabs.select { |tab| tab.permitted.call(@view) }.map do |tab|
          Tab.new(label: tab.label, href: tab.href_for(@view), icon: tab.icon_for(@view), ios_system_image: tab.ios_system_image, android_icon: tab.android_icon, sections: [ tab.section ].compact)
        end
      end

      def area_tabs
        shown = configuration.app_areas.select { |area| area.on_by_default && area_pages(area).any? }
        in_person_order(shown).map { |area| area_tab(area) }
      end

      def area_tab(area)
        Tab.new(label: area.name, href: opened_page(area).href_for(@view), icon: area.icon_for(@view), ios_system_image: area.ios_system_image, android_icon: area.android_icon, sections: area.groups)
      end

      def more_tab_needed?(shown)
        configuration.more_page_tab && (permitted_groups.flat_map(&:last).map { |page| page.href_for(@view) } - shown.map(&:href)).any?
      end

      def more_tab
        more = configuration.more_page_tab
        Tab.new(label: MORE_LABEL, href: more.href, icon: more.icon, ios_system_image: more.ios_system_image, android_icon: more.android_icon, sections: [])
      end

      def opened_page(area)
        pages = area_pages(area)
        pages.find { |page| page.key == area.opens } || pages.first
      end

      def in_person_order(areas)
        return areas if saved_order.empty?

        labels = arranged_groups.map { |group, _pages| group.label }
        areas.each_with_index
          .sort_by { |area, declared| [ area.groups.filter_map { |label| labels.index(label) }.min, declared ] }
          .map(&:first)
      end

      def area_pages(area)
        arranged_groups.select { |group, _pages| area.groups.include?(group.label) }.flat_map(&:last)
      end

      def arranged_groups
        @arranged_groups ||= KeystoneUi::NavigationOrder.new(saved_order).arrange(permitted_groups)
      end

      def permitted_groups
        KeystoneUi.configuration.navigation_groups
          .map { |group| [ group, group.tabs_permitted_for(@view) ] }
          .reject { |_group, pages| pages.empty? }
      end

      def saved_order
        @saved_order ||= begin
          value = KeystoneUi.configuration.supplied_preference(@view, :navigation)&.dig(:value)
          value.is_a?(Hash) && value["order"].is_a?(Array) ? value["order"] : []
        end
      end

      def configuration
        KeystoneUi::App.configuration
      end
    end
  end
end
