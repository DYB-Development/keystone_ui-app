# frozen_string_literal: true

module KeystoneUi
  module App
    class Configuration
      BottomTab = Struct.new(:label, :href, :icon, :permitted, :section, keyword_init: true)

      attr_reader :bottom_tabs

      def initialize
        @bottom_tabs = []
      end

      def bottom_tab(label:, href:, icon:, permitted:, section:)
        @bottom_tabs << BottomTab.new(label: label, href: href, icon: icon, permitted: permitted, section: section)
      end
    end
  end
end
