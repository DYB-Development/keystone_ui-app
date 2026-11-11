# frozen_string_literal: true

module KeystoneUi
  module App
    class AccountMenuComponent < ViewComponent::Base
      WRAPPER_CLASSES = "ks-app-account-menu flex items-center gap-2"
      BUTTON_CLASSES = "ks-nav-item w-full text-left cursor-pointer"

      SWITCHER_CLASSES = "ks-app-account-switcher"
      BELL_CLASSES = "ks-app-notifications-bell ks-nav-item inline-flex items-center gap-1"
      BELL_ICON = <<~SVG.freeze
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" class="size-5" aria-hidden="true">
          <path stroke-linecap="round" stroke-linejoin="round" d="M14.857 17.082a23.848 23.848 0 0 0 5.454-1.31A8.967 8.967 0 0 1 18 9.75V9A6 6 0 0 0 6 9v.75a8.967 8.967 0 0 1-2.312 6.022c1.733.64 3.56 1.085 5.455 1.31m5.714 0a24.255 24.255 0 0 1-5.714 0m5.714 0a3 3 0 1 1-5.714 0" />
        </svg>
      SVG

      def notifications
        KeystoneUi::App.configuration.notifications_link
      end

      def unread_count
        notifications.unread_count_for(helpers).to_i
      end

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
