# frozen_string_literal: true

module KeystoneUi
  module App
    class MorePageComponent < ViewComponent::Base
      def rows
        KeystoneUi.configuration.navigation_groups.flat_map(&:tabs).map do |page|
          { label: page.label, href: page.href_for(helpers) }
        end
      end
    end
  end
end
