# frozen_string_literal: true

require "test_helper"

class SectionMenuTest < ActionDispatch::IntegrationTest
  test "on a phone browser a page in a section shows the section's name in the top bar" do
    get "/pages/plain", params: { tab: "quotes" }

    assert_select "header [class~='lg:hidden'] .ks-nav-dropdown-trigger", text: /Sales/
  end

  test "on a phone browser the section's button opens a menu of the section's tabs" do
    get "/pages/plain", params: { tab: "quotes" }

    assert_select "header .ks-nav-dropdown-menu a[href='/pages/plain?tab=orders']", text: "Orders"
  end
end
