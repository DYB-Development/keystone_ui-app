# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class BottomTabsTest < ActionDispatch::IntegrationTest
  NATIVE_APP = { "User-Agent" => "Hotwire Native iOS; Turbo Native iOS" }.freeze

  test "on a phone browser the shell draws the declared bottom tabs at the foot of the page" do
    get "/pages/plain"

    assert_select "body > nav.ks-bottom-nav[class~='lg:hidden'] a[href='/pages/plain?tab=quotes']", text: "Sales"
  end

  test "the bottom tab for the section the page belongs to is marked active" do
    get "/pages/plain", params: { tab: "quotes" }

    assert_select "nav.ks-bottom-nav a.active", text: "Sales"
  end

  test "on a section's page only that section's bottom tab is marked active" do
    get "/pages/plain", params: { tab: "quotes" }

    assert_select "nav.ks-bottom-nav a.active", count: 1
  end

  test "on the page a bottom tab with no section links to, that tab is marked active" do
    get "/pages/plain"

    assert_select "nav.ks-bottom-nav a.active", text: "Home"
  end

  test "on a page in no section that no bottom tab links to, no bottom tab is marked active" do
    get "/pages/show"

    assert_select "nav.ks-bottom-nav a.active", count: 0
  end

  test "a bottom tab the person is not permitted to see is left out" do
    get "/pages/plain"

    assert_select "nav.ks-bottom-nav a", text: "Refunds", count: 0
  end

  test "inside the native app the shell draws no bottom tabs" do
    get "/pages/plain", headers: NATIVE_APP

    assert_select "nav.ks-bottom-nav", count: 0
  end

  test "a page that asks for no bottom tabs is drawn without them" do
    get "/pages/no_bottom_tabs"

    assert_select "nav.ks-bottom-nav", count: 0
  end

  test "an app that declares no bottom tabs shows no bottom bar" do
    KeystoneUi::App.stub(:configuration, KeystoneUi::App::Configuration.new) { get "/pages/plain" }

    assert_select "nav.ks-bottom-nav", count: 0
  end

  test "a bottom tab whose address is worked out from the page links to that address" do
    get "/pages/plain"

    assert_select "nav.ks-bottom-nav a[href='/pages/plain?tab=orders&from=/pages/plain']", text: "Orders"
  end

  test "a bottom tab whose icon is drawn by the page shows that icon" do
    get "/pages/plain"

    assert_select "nav.ks-bottom-nav a svg#orders-icon"
  end
end
