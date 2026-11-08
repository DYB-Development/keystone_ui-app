# frozen_string_literal: true

module KeystoneUi
  module App
    class PageActionsComponent < ViewComponent::Base
      def render?
        show_actions?
      end

      def show_actions?
        helpers.content_for?(:show_page) && helpers.content_for?(:show_page_actions)
      end
    end
  end
end
