# frozen_string_literal: true

require "keystone_ui/app/current_section"

module KeystoneUi
  module App
    class SectionMenuComponent < ViewComponent::Base
      WRAPPER_CLASSES = "lg:hidden"

      def render?
        section.present?
      end

      def title
        helpers.content_for(:mobile_page_title).presence || section.label
      end

      def section
        @section ||= KeystoneUi::App::CurrentSection.new(helpers).group
      end
    end
  end
end
