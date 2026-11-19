# frozen_string_literal: true

module KeystoneUi
  module App
    class AreaChoices
      def self.for(configuration, view)
        new(configuration, account: configuration.account_supplier&.call(view))
      end

      def initialize(configuration, account:)
        @configuration = configuration
        @account = account&.to_s
      end

      def on?(area_name)
        saved.fetch(area_name) { declared(area_name).on_by_default }
      end

      def turn(area_name, on:)
        AreaChoice.find_or_initialize_by(account_key: @account, area_name: area_name).update!(on: on)
        @saved = nil
      end

      private

      def saved
        return {} unless @account

        @saved ||= AreaChoice.where(account_key: @account).pluck(:area_name, :on).to_h
      end

      def declared(area_name)
        @configuration.app_areas.find { |area| area.name == area_name }
      end
    end
  end
end
