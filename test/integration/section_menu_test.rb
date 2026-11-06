# frozen_string_literal: true

require "test_helper"

class SectionMenuTest < ActionDispatch::IntegrationTest
  test "on a phone browser a page in a section shows the section's name in the top bar" do
    get "/pages/plain", params: { tab: "quotes" }

    assert_select "header [class~='lg:hidden'] .ks-nav-dropdown-trigger", text: /Sales/
  end
end
