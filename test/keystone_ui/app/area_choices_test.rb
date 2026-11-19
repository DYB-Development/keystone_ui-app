# frozen_string_literal: true

require "test_helper"

class KeystoneUi::App::AreaChoicesTest < ActiveSupport::TestCase
  test "an area with no saved choice for the account follows the default the app declared" do
    configuration = KeystoneUi::App::Configuration.new
    configuration.app_area(name: "Selling", description: "Quotes", groups: [ "Sales" ], on_by_default: false, icon: "<svg></svg>", ios_system_image: "cart", android_icon: "cart")

    assert_equal false, KeystoneUi::App::AreaChoices.new(configuration, account: "acme").on?("Selling")
  end
end
