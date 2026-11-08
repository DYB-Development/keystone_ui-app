# frozen_string_literal: true

require "test_helper"

class BottomTabsTest < ActionDispatch::IntegrationTest
  test "on a phone browser the shell draws the declared bottom tabs at the foot of the page" do
    get "/pages/plain"

    assert_select "body > nav.ks-bottom-nav[class~='lg:hidden'] a[href='/pages/plain?tab=quotes']", text: "Sales"
  end
end
