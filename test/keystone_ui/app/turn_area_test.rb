# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class KeystoneUi::App::TurnAreaTest < ActiveSupport::TestCase
  Account = Struct.new(:id)

  test "turning an area off from the settings section saves that choice for the account" do
    app = KeystoneUi::App::Configuration.new
    app.app_area(name: "Selling", description: "Quotes", groups: [ "Sales" ], on_by_default: true, icon: "<svg></svg>", ios_system_image: "cart", android_icon: "cart")

    on = KeystoneUi::App.stub(:configuration, app) do
      KeystoneUi::App::TurnArea.new(values: { area: "Selling", on: "false" }, person: nil, account: Account.new(7)).call
      KeystoneUi::App::AreaChoices.new(app, account: 7).on?("Selling")
    end

    assert_equal false, on
  end
end
