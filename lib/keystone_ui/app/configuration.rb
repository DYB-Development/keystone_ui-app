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

      attr_reader :bottom_tabs, :native_rules

      def initialize
        @bottom_tabs = []
        @native_rules = []
      end

      def bottom_tab(label:, href:, icon:, permitted:, section:, ios_system_image: nil, android_icon: nil)
        @bottom_tabs << BottomTab.new(label: label, href: href, icon: icon, permitted: permitted, section: section, ios_system_image: ios_system_image, android_icon: android_icon)
      end

      def native_rule(patterns:, properties:)
        @native_rules << { patterns: patterns, properties: properties }
      end
    end
  end
end
