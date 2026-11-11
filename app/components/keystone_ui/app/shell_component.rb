# frozen_string_literal: true

require "keystone_ui/theme_choice"

module KeystoneUi
  module App
    class ShellComponent < ViewComponent::Base
      renders_one :head
      renders_one :flash
      renders_one :logo
      renders_one :menus
      renders_one :phone_menus
      renders_one :footer

      PHONE_ONLY = "lg:hidden"
      PAGE_SIGNALS = %i[show_page form_page].freeze
      VIEWPORT = "width=device-width, initial-scale=1"
      NATIVE_APP_VIEWPORT = "#{VIEWPORT}, maximum-scale=1.0, user-scalable=0"
      NATIVE_APP_STYLE = '[data-bridge-components~="form"] [data-controller~="bridge--form"] [type="submit"] { display: none; }'

      attr_reader :body

      def initialize(body: {})
        @body = body
      end

      def native_app?
        return @native_app if defined?(@native_app)

        @native_app = helpers.hotwire_native_app?
      end

      def dark_mode?
        theme_choice.mode == "dark"
      end

      def theme_choice
        KeystoneUi::ThemeChoice.new(helpers.cookies[KeystoneUi::ThemeChoice::COOKIE], supplied: KeystoneUi.configuration.supplied_theme_mode(helpers))
      end

      def viewport
        native_app? ? NATIVE_APP_VIEWPORT : VIEWPORT
      end

      def phone_header_shown?
        page_signal && !native_app?
      end

      def account_menu?
        KeystoneUi::App.configuration.account_links.any?
      end

      def footer_shown?
        !native_app? && !helpers.content_for?(:hide_footer)
      end

      def bottom_tabs_shown?
        !native_app? && !helpers.content_for?(:hide_bottom_tabs)
      end

      def page_signal
        PAGE_SIGNALS.find { |signal| helpers.content_for?(signal) }
      end

      def page_signalled(name)
        helpers.content_for(:"#{page_signal}_#{name}")
      end
    end
  end
end
