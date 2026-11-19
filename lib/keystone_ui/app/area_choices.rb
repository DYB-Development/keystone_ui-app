# frozen_string_literal: true

module KeystoneUi
  module App
    class AreaChoices
      def initialize(configuration, account:)
        @configuration = configuration
        @account = account.to_s
      end

      def on?(area_name)
        declared(area_name).on_by_default
      end

      private

      def declared(area_name)
        @configuration.app_areas.find { |area| area.name == area_name }
      end
    end
  end
end
