# frozen_string_literal: true

module KeystoneUi
  module App
    class AccountPageComponent < ViewComponent::Base
      PERSON_CLASSES = "ks-app-account-person flex min-w-0 items-center gap-3"
      NAME_CLASSES = "ks-paragraph block font-semibold break-words"
      EMAIL_CLASSES = "ks-value-list-note block truncate"
      ROW_CLASSES = "ks-value-list-row items-center no-underline"
      LABEL_CLASSES = "ks-paragraph ks-settings-link-label block min-w-0 flex-1 break-words"

      def accounts
        KeystoneUi::App.configuration.accounts(helpers)
      end

      def person
        KeystoneUi::App.configuration.person(helpers)
      end
    end
  end
end
