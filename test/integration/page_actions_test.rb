# frozen_string_literal: true

require "test_helper"

class PageActionsTest < ActionDispatch::IntegrationTest
  NATIVE_APP = { "User-Agent" => "Hotwire Native iOS; Turbo Native iOS" }.freeze

  test "on a phone browser a show page's actions open from an ellipsis button in the top bar" do
    get "/pages/show_actions"

    assert_select "header button[aria-label=Actions] + .ks-action-menu a[href='/invoices/1/edit']", text: "Edit"
  end

  test "on a phone browser a form page's one action shows in the top bar" do
    get "/pages/form_action"

    assert_select "header [class~='lg:hidden'] a#form-action[href='/additions/new']", text: "Add"
  end

  test "on a phone browser a page with several ways to add opens them from a plus button in the top bar" do
    get "/pages/add_menu"

    assert_select "header button[aria-label=Add] + .ks-action-menu a[href='/lists/import']", text: "Import a list"
  end

  test "inside the native app a show page draws no action menu" do
    get "/pages/show_actions", headers: NATIVE_APP

    assert_select ".ks-action-menu", count: 0
  end
end
