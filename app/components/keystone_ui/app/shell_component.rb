# frozen_string_literal: true

module KeystoneUi
  module App
    class ShellComponent < ViewComponent::Base
      renders_one :head
      renders_one :flash
      renders_one :logo
      renders_one :menus
      renders_one :footer

      def footer_shown?
        !helpers.content_for?(:hide_footer)
      end
    end
  end
end
