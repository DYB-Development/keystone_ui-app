# frozen_string_literal: true

module KeystoneUi
  module App
    class AccountMenuComponent < ViewComponent::Base
      WRAPPER_CLASSES = "ks-app-account-menu flex items-center gap-2"

      def links
        KeystoneUi::App.configuration.account_links
      end
    end
  end
end
