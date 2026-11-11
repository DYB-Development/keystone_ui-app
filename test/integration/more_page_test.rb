# frozen_string_literal: true

require "test_helper"

class MorePageTest < ActionDispatch::IntegrationTest
  test "an app draws the More page in one of its own pages with one call" do
    get "/pages/more"

    assert_select "main a[href='/pages/plain?tab=quotes']", text: "Quotes"
  end

  test "each group's pages are listed under a heading with the group's label" do
    get "/pages/more"

    assert_equal [ "Quotes", "Orders" ], links_in_group("Sales")
  end

  test "a page the person may not open is left off the More page" do
    get "/pages/more"

    assert_select "main a", text: "Refunds", count: 0
  end

  private

  def links_in_group(label)
    group = css_select("main section").find { |section| section.at_css("h2")&.text&.strip == label }
    group ? group.css("a").map { |link| link.text.strip } : []
  end
end
