# frozen_string_literal: true

require "test_helper"

class NativeMenuButtonTest < ActionDispatch::IntegrationTest
  NATIVE_APP = { "User-Agent" => "Hotwire Native iOS; Turbo Native iOS" }.freeze

  def sent_menu
    JSON.parse(css_select("[data-controller='bridge--menu-button']").first["data-bridge--menu-button-menu-value"])
  end

  test "inside the native app the native menu button lists the section's tabs" do
    get "/pages/plain", params: { tab: "quotes" }, headers: NATIVE_APP

    assert_equal [ { "title" => "Quotes", "path" => "/pages/plain?tab=quotes" }, { "title" => "Orders", "path" => "/pages/plain?tab=orders" } ], sent_menu["items"]
  end

  test "inside the native app a page that belongs to no section sends no tabs to the native menu button" do
    get "/pages/plain", headers: NATIVE_APP

    assert_equal [], sent_menu["items"]
  end

  test "in a browser the page draws no native menu button" do
    get "/pages/plain", params: { tab: "quotes" }

    assert_select "[data-controller='bridge--menu-button']", count: 0
  end
end
