# frozen_string_literal: true

module KeystoneUi
  module App
    class Configuration
      BottomTab = Struct.new(:label, :href, :icon, :permitted, :section, :ios_system_image, :android_icon, keyword_init: true) do
        def href_for(view)
          href.respond_to?(:call) ? href.call(view) : href
        end

        def icon_for(view)
          icon.respond_to?(:call) ? icon.call(view) : icon
        end
      end

      AppArea = Struct.new(:name, :description, :groups, :on_by_default, :opens, :icon, :ios_system_image, :android_icon, keyword_init: true)

      MorePage = Struct.new(:href, :icon, :ios_system_image, :android_icon, keyword_init: true)

      attr_reader :bottom_tabs, :app_areas, :more_page_tab, :native_rules, :native_settings

      def initialize
        @bottom_tabs = []
        @app_areas = []
        @native_rules = []
        @native_settings = {}
      end

      def bottom_tab(label:, href:, icon:, permitted:, section:, ios_system_image: nil, android_icon: nil)
        @bottom_tabs << BottomTab.new(label: label, href: href, icon: icon, permitted: permitted, section: section, ios_system_image: ios_system_image, android_icon: android_icon)
      end

      def app_area(name:, description:, groups:, on_by_default:, icon:, ios_system_image:, android_icon:, opens: nil)
        @app_areas << AppArea.new(name: name, description: description, groups: groups, on_by_default: on_by_default, opens: opens, icon: icon, ios_system_image: ios_system_image, android_icon: android_icon)
      end

      def more_page(href:, icon:, ios_system_image:, android_icon:)
        @more_page_tab = MorePage.new(href: href, icon: icon, ios_system_image: ios_system_image, android_icon: android_icon)
      end

      def native_rule(patterns:, properties:)
        @native_rules << { patterns: patterns, properties: properties }
      end

      def native_setting(name, value)
        @native_settings[name] = value
      end
    end
  end
end
