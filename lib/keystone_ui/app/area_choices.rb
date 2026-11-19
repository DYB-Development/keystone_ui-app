# frozen_string_literal: true

module KeystoneUi
  module App
    class AreaChoices
      def initialize(configuration, account:)
        @configuration = configuration
        @account = account.to_s
      end

      def on?(area_name)
        saved = AreaChoice.find_by(account_key: @account, area_name: area_name)
        saved ? saved.on : declared(area_name).on_by_default
      end

      def turn(area_name, on:)
        AreaChoice.find_or_initialize_by(account_key: @account, area_name: area_name).update!(on: on)
      end

      private

      def declared(area_name)
        @configuration.app_areas.find { |area| area.name == area_name }
      end
    end
  end
end
