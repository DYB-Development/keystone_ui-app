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

  test "the Android app receives the same tabs with each tab's icon as one JSON-encoded string" do
    get "/hotwire/android/path_configuration.json"

    assert_equal [
      { "title" => "Home", "path" => "/pages/plain", "icon" => "home" },
      { "title" => "Sales", "path" => "/pages/plain?tab=quotes", "icon" => "shopping_cart" },
      { "title" => "Orders", "path" => "/pages/plain?tab=orders&from=/hotwire/android/path_configuration.json", "icon" => "inventory" }
    ], JSON.parse(response.parsed_body.dig("settings", "tabs"))
  end

  test "the iOS app opens new and edit pages as modals" do
    get "/hotwire/ios/path_configuration.json"

    assert_equal [ { "patterns" => [ "/new$", "/edit$" ], "properties" => { "context" => "modal" } } ], response.parsed_body["rules"]
  end

  test "the Android app opens every page in the web fragment and new and edit pages as modals" do
    get "/hotwire/android/path_configuration.json"

    assert_equal [
      { "patterns" => [ ".*" ], "properties" => { "context" => "default", "uri" => "hotwire://fragment/web", "fallback_uri" => "hotwire://fragment/web", "pull_to_refresh_enabled" => true } },
      { "patterns" => [ "/new$", "/edit$" ], "properties" => { "context" => "modal", "pull_to_refresh_enabled" => false } }
    ], response.parsed_body["rules"]
  end
end
