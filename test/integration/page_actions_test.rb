# frozen_string_literal: true

require "test_helper"

class PageActionsTest < ActionDispatch::IntegrationTest
  NATIVE_APP = { "User-Agent" => "Hotwire Native iOS; Turbo Native iOS" }.freeze

  test "on a phone browser a show page's actions open from an ellipsis button in the top bar" do
    get "/pages/show_actions"

    assert_select "header button[aria-label=Actions] + .ks-action-menu a[href='/invoices/1/edit']", text: "Edit"
  end
end
