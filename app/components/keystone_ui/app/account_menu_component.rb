# frozen_string_literal: true

module KeystoneUi
  module App
    class AccountMenuComponent < ViewComponent::Base
      WRAPPER_CLASSES = "ks-app-account-menu flex items-center gap-2"
      BUTTON_CLASSES = "ks-nav-item w-full text-left cursor-pointer"

      def links
        KeystoneUi::App.configuration.account_links.select { |link| link.permitted.call(helpers) }
      end
    end
  end
end
