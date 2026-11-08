# frozen_string_literal: true

require "test_helper"

class BottomTabsTest < ActionDispatch::IntegrationTest
  test "on a phone browser the shell draws the declared bottom tabs at the foot of the page" do
    get "/pages/plain"

    assert_select "body > nav.ks-bottom-nav[class~='lg:hidden'] a[href='/pages/plain?tab=quotes']", text: "Sales"
  end

  test "the bottom tab for the section the page belongs to is marked active" do
    get "/pages/plain", params: { tab: "quotes" }

    assert_select "nav.ks-bottom-nav a.active", text: "Sales"
  end

  test "on a page in no section no bottom tab is marked active" do
    get "/pages/plain"

    assert_select "nav.ks-bottom-nav a.active", count: 0
  end
end
