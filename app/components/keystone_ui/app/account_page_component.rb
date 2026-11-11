# frozen_string_literal: true

module KeystoneUi
  module App
    class AccountPageComponent < ViewComponent::Base
      PERSON_CLASSES = "ks-app-account-person flex min-w-0 items-center gap-3"
      NAME_CLASSES = "ks-paragraph block font-semibold break-words"

      def person
        KeystoneUi::App.configuration.person(helpers)
      end
    end
  end
end
