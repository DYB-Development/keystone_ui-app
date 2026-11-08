# frozen_string_literal: true

module KeystoneUi
  module App
    class NativeAddButtonComponent < ViewComponent::Base
      CONTROLLER = "bridge--add-button"

      def render?
        helpers.content_for?(:mobile_action_url)
      end

      def call
        tag.div(data: { controller: CONTROLLER, "#{CONTROLLER}-url-value": signal(:url), "#{CONTROLLER}-label-value": signal(:label), "#{CONTROLLER}-method-value": signal(:method).presence })
      end

      def signal(name)
        helpers.content_for(:"mobile_action_#{name}")
      end
    end
  end
end
