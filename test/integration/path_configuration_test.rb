# frozen_string_literal: true

require "test_helper"

class PathConfigurationTest < ActionDispatch::IntegrationTest
  test "the iOS app receives a native tab for each bottom tab the person is permitted to see with its system image" do
    get "/hotwire/ios/path_configuration.json"

    assert_equal [
      { "title" => "Home", "path" => "/pages/plain", "ios_system_image_name" => "house" },
      { "title" => "Sales", "path" => "/pages/plain?tab=quotes", "ios_system_image_name" => "cart" },
      { "title" => "Orders", "path" => "/pages/plain?tab=orders&from=/hotwire/ios/path_configuration.json", "ios_system_image_name" => "shippingbox" }
    ], response.parsed_body.dig("settings", "tabs")
  end
end
