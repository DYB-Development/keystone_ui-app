# frozen_string_literal: true

module KeystoneUi
  module App
    class NativeAddButtonComponent < ViewComponent::Base
      CONTROLLER = "bridge--add-button"

      def call
        tag.div(data: { controller: CONTROLLER, "#{CONTROLLER}-url-value": helpers.content_for(:mobile_action_url) })
      end
    end
  end
end
