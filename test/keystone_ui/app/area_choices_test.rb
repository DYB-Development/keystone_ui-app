# frozen_string_literal: true

require "test_helper"

class KeystoneUi::App::AreaChoicesTest < ActiveSupport::TestCase
  test "an account's saved choice for an area is read back by a later lookup" do
    KeystoneUi::App::AreaChoices.new(selling_off_by_default, account: "acme").turn("Selling", on: true)

    assert_equal true, KeystoneUi::App::AreaChoices.new(selling_off_by_default, account: "acme").on?("Selling")
  end

  test "an area with no saved choice for the account follows the default the app declared" do
    configuration = KeystoneUi::App::Configuration.new
    configuration.app_area(name: "Selling", description: "Quotes", groups: [ "Sales" ], on_by_default: false, icon: "<svg></svg>", ios_system_image: "cart", android_icon: "cart")

    assert_equal false, KeystoneUi::App::AreaChoices.new(configuration, account: "acme").on?("Selling")
  end

  private

  def selling_off_by_default
    configuration = KeystoneUi::App::Configuration.new
    configuration.app_area(name: "Selling", description: "Quotes", groups: [ "Sales" ], on_by_default: false, icon: "<svg></svg>", ios_system_image: "cart", android_icon: "cart")
    configuration
  end
end
