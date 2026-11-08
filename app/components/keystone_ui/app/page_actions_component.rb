# frozen_string_literal: true

module KeystoneUi
  module App
    class PageActionsComponent < ViewComponent::Base
      FORM_ACTION_CLASSES = "flex items-center lg:hidden"
      ADD_MENU_CLASSES = Keystone::Ui::MobileActionsComponent::WRAPPER_CLASSES
      ADD_BUTTON_CLASSES = Keystone::Ui::MobileActionsComponent::BUTTON_CLASSES
      ADD_OPTIONS_CLASSES = Keystone::Ui::MobileActionsComponent::DROPDOWN_CLASSES
      PLUS_ICON = Keystone::Ui::MobileActionComponent::PLUS_ICON

      def render?
        form_action? || show_actions? || add_menu?
      end

      def form_action?
        helpers.content_for?(:form_page) && helpers.content_for?(:form_page_action)
      end

      def show_actions?
        helpers.content_for?(:show_page) && helpers.content_for?(:show_page_actions)
      end

      def add_menu?
        helpers.content_for?(:mobile_action_menu)
      end
    end
  end
end
