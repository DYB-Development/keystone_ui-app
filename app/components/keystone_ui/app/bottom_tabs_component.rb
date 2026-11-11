# frozen_string_literal: true

require "uri"
require "rack/utils"
require "keystone_ui/app/current_section"

module KeystoneUi
  module App
    class BottomTabsComponent < ViewComponent::Base
      def render?
        tabs.any?
      end

      def tabs
        @tabs ||= KeystoneUi::App.configuration.bottom_tabs.select { |tab| tab.permitted.call(helpers) }
      end

      def active?(tab)
        return in_section?(tab) if tab.section

        tabs.none? { |other| in_section?(other) } && on_page?(tab)
      end

      def in_section?(tab)
        section.present? && tab.section == section.label
      end

      def on_page?(tab)
        address = URI.parse(tab.href_for(helpers))
        address.path == request.path &&
          Rack::Utils.parse_query(address.query).all? { |name, value| request.query_parameters[name] == value }
      end

      def section
        @section ||= KeystoneUi::App::CurrentSection.new(helpers).group
      end
    end
  end
end
