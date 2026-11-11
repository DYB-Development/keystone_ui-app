# frozen_string_literal: true

require "test_helper"

class MorePageTest < ActionDispatch::IntegrationTest
  test "an app draws the More page in one of its own pages with one call" do
    get "/pages/more"

    assert_select "main a[href='/pages/plain?tab=quotes']", text: "Quotes"
  end

  test "a page the person may not open is left off the More page" do
    get "/pages/more"

    assert_select "main a", text: "Refunds", count: 0
  end
end
