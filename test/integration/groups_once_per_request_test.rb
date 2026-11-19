# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class GroupsOncePerRequestTest < ActionDispatch::IntegrationTest
  test "a navigation page's permission check runs once for the bottom bar, group bar and More page together, beside keystone_ui's desktop menu" do
    checks = 0
    get_more_page(permitted: ->(_view) { checks += 1; true })

    assert_equal 2, checks
  end

  private

  def get_more_page(permitted: ->(_view) { true }, count: nil)
    navigation = KeystoneUi::Configuration.new
    navigation.navigation_group("Sales") do |group|
      group.tab(:quotes, label: "Quotes", href: "/pages/plain?tab=quotes", permitted: permitted, count: count)
      group.tab(:orders, label: "Orders", href: "/pages/plain?tab=orders", permitted: ->(_view) { true })
    end
    navigation.current_tab_supplier = ->(view) { view.params[:tab]&.to_sym }
    KeystoneUi.stub(:configuration, navigation) { get "/pages/more", params: { tab: "quotes" } }
  end
end
