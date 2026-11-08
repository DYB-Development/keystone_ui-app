# frozen_string_literal: true

module KeystoneUi
  module App
    class PageActionsComponent < ViewComponent::Base
      FORM_ACTION_CLASSES = "flex items-center lg:hidden"

      def render?
        form_action? || show_actions?
      end

      def form_action?
        helpers.content_for?(:form_page) && helpers.content_for?(:form_page_action)
      end

      def show_actions?
        helpers.content_for?(:show_page) && helpers.content_for?(:show_page_actions)
      end
    end
  end
end
