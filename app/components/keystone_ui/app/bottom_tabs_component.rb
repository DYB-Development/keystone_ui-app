# frozen_string_literal: true

module KeystoneUi
  module App
    class BottomTabsComponent < ViewComponent::Base
      def tabs
        KeystoneUi::App.configuration.bottom_tabs
      end
    end
  end
end
