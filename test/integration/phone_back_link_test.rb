# frozen_string_literal: true

require "test_helper"

class PhoneBackLinkTest < ActionDispatch::IntegrationTest
  setup do
    @trail_supplier = KeystoneUi.configuration.trail_supplier
    KeystoneUi.configuration.trail_supplier = ->(view) { view.params[:parent] ? [["Sales", "/pages/plain"], ["Quote", view.params[:parent]]] : [] }
  end

  teardown do
    KeystoneUi.configuration.trail_supplier = @trail_supplier
  end

  test "on a phone browser a page with a breadcrumb trail shows a back link to the last breadcrumb" do
    get "/pages/plain", params: { tab: "quotes", parent: "/pages/show" }

    assert_select "header [class~='lg:hidden'] a[aria-label='Back'][href='/pages/show']"
  end
end
