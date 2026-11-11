# frozen_string_literal: true

module KeystoneUi
  module App
    class AvatarComponent < ViewComponent::Base
      CLASSES = "ks-app-avatar inline-flex size-8 shrink-0 items-center justify-center overflow-hidden rounded-full bg-gray-200 text-sm font-semibold text-gray-700 dark:bg-gray-700 dark:text-gray-100"

      def call
        tag.span(initial, class: CLASSES)
      end

      private

      def person
        KeystoneUi::App.configuration.person(helpers)
      end

      def initial
        person[:name].to_s.strip[0].to_s.upcase
      end
    end
  end
end
