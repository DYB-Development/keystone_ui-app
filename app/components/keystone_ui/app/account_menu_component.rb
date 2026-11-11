# frozen_string_literal: true

module KeystoneUi
  module App
    class AccountMenuComponent < ViewComponent::Base
      WRAPPER_CLASSES = "ks-app-account-menu flex items-center gap-2"
      BUTTON_CLASSES = "ks-nav-item w-full text-left cursor-pointer"

      SWITCHER_CLASSES = "ks-app-account-switcher"

      def accounts
        KeystoneUi::App.configuration.accounts(helpers)
      end

      def current_account
        accounts.find { |account| account[:current] }
      end

      def links
        KeystoneUi::App.configuration.account_links.select { |link| link.permitted.call(helpers) }
      end
    end
  end
end
