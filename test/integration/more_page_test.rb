# frozen_string_literal: true

require "test_helper"

class MorePageTest < ActionDispatch::IntegrationTest
  test "an app draws the More page in one of its own pages with one call" do
    get "/pages/more"

    assert_select "main a[href='/pages/plain?tab=quotes']", text: "Quotes"
  end
end
