# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class SectionMenuTest < ActionDispatch::IntegrationTest
  NATIVE_APP = { "User-Agent" => "Hotwire Native iOS; Turbo Native iOS" }.freeze

  test "on a phone browser a page in a group shows a bar reading the group's label, a dot and the page's label" do
    get "/pages/header", params: { tab: "quotes" }

    assert_equal "Sales · Quotes", css_select("header [class~='lg:hidden'] .ks-nav-dropdown-trigger").first.text.squish
  end

  test "on a phone browser the section's button opens a menu of the section's tabs" do
    get "/pages/plain", params: { tab: "quotes" }

    assert_select "header .ks-nav-dropdown-menu a[href='/pages/plain?tab=orders']", text: "Orders"
  end

  test "the phone section menu marks the tab the page belongs to as active" do
    get "/pages/plain", params: { tab: "quotes" }

    assert_select "header .ks-nav-dropdown-menu a.active", text: "Quotes"
  end

  test "the phone section menu leaves out tabs the person is not permitted to see" do
    get "/pages/plain", params: { tab: "quotes" }

    assert_select "header .ks-nav-dropdown-menu a", text: "Refunds", count: 0
  end

  test "inside the native app the page draws no web section menu" do
    get "/pages/plain", params: { tab: "quotes" }, headers: NATIVE_APP

    assert_select "header .ks-nav-dropdown", count: 0
  end

  test "on a phone browser a page that belongs to no section shows no section menu" do
    get "/pages/plain"

    assert_select "header .ks-nav-dropdown", count: 0
  end

  test "on a phone browser a page declared on its own outside any group shows no bar" do
    navigation = KeystoneUi::Configuration.new
    navigation.navigation_tab(:inbox, label: "Inbox", href: "/pages/plain?tab=inbox", permitted: ->(_view) { true })
    navigation.current_tab_supplier = ->(view) { view.params[:tab]&.to_sym }

    KeystoneUi.stub(:configuration, navigation) { get "/pages/plain", params: { tab: "inbox" } }

    assert_select "header .ks-nav-dropdown", count: 0
  end
end
