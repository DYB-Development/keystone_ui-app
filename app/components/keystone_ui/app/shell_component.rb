# frozen_string_literal: true

module KeystoneUi
  module App
    class ShellComponent < ViewComponent::Base
      renders_one :head
      renders_one :flash
      renders_one :logo
      renders_one :menus
      renders_one :footer

      PAGE_SIGNALS = %i[show_page form_page].freeze

      def footer_shown?
        !helpers.content_for?(:hide_footer)
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
