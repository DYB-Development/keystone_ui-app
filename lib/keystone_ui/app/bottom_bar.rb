# frozen_string_literal: true

module KeystoneUi
  module App
    class BottomBar
      Tab = Struct.new(:label, :href, :icon, :ios_system_image, :android_icon, :sections, keyword_init: true)

      def initialize(view)
        @view = view
      end

      def tabs
        fixed_tabs + area_tabs
      end

      private

      def fixed_tabs
        configuration.bottom_tabs.select { |tab| tab.permitted.call(@view) }.map do |tab|
          Tab.new(label: tab.label, href: tab.href_for(@view), icon: tab.icon_for(@view), ios_system_image: tab.ios_system_image, android_icon: tab.android_icon, sections: [ tab.section ].compact)
        end
      end

      def area_tabs
        configuration.app_areas.filter_map { |area| area_tab(area) }
      end

      def area_tab(area)
        pages = area_pages(area)
        return if pages.empty?

        Tab.new(label: area.name, href: pages.first.href_for(@view), icon: area.icon, ios_system_image: area.ios_system_image, android_icon: area.android_icon, sections: area.groups)
      end

      def area_pages(area)
        KeystoneUi.configuration.navigation_groups
          .select { |group| area.groups.include?(group.label) }
          .flat_map { |group| group.tabs_permitted_for(@view) }
      end

      def configuration
        KeystoneUi::App.configuration
      end
    end
  end
end
