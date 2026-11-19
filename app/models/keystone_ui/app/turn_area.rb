# frozen_string_literal: true

module KeystoneUi
  module App
    class TurnArea
      Result = Struct.new(:ok?, :message)

      def initialize(values:, person: nil, account: nil)
        @values = values
        @person = person
        @account = account
      end

      def call
        AreaChoices.new(KeystoneUi::App.configuration, account: account_key).turn(@values[:area], on: @values[:on].to_s == "true")
        Result.new(true, nil)
      end

      private

      def account_key
        @account.respond_to?(:id) ? @account.id : @account
      end
    end
  end
end
