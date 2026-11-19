# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class GroupsOncePerRequestTest < ActionDispatch::IntegrationTest
  test "a navigation page's permission check runs once for the bottom bar, group bar and More page together, beside keystone_ui's desktop menu" do
    checks = 0
    get_more_page(permitted: ->(_view) { checks += 1; true })

    assert_equal 2, checks
  end

  test "a navigation page's count is worked out once for the bottom bar, group bar and More page together, beside keystone_ui's desktop menu" do
    counts = 0
    get_more_page(count: ->(_view) { counts += 1; 2 })

    assert_equal 2, counts
  end

  test "an account's area choices are read from the database once per request" do
    reads = 0
    counter = ->(*, payload) { reads += 1 if payload[:sql].include?("keystone_ui_app_area_choices") && !%w[SCHEMA CACHE].include?(payload[:name]) }
    ActiveSupport::Notifications.subscribed(counter, "sql.active_record") do
      get_more_page(areas: true)
    end

    assert_equal 1, reads
  end

  private

  def get_more_page(permitted: ->(_view) { true }, count: nil, areas: false)
    navigation = KeystoneUi::Configuration.new
    navigation.navigation_group("Sales") do |group|
      group.tab(:quotes, label: "Quotes", href: "/pages/plain?tab=quotes", permitted: permitted, count: count)
      group.tab(:orders, label: "Orders", href: "/pages/plain?tab=orders", permitted: ->(_view) { true })
    end
    navigation.current_tab_supplier = ->(view) { view.params[:tab]&.to_sym }
    app = KeystoneUi::App::Configuration.new
    if areas
      app.app_area(name: "Selling", description: "Quotes", groups: [ "Sales" ], on_by_default: true, icon: "<svg></svg>", ios_system_image: "cart", android_icon: "cart")
      app.more_page(href: "/pages/more", icon: "<svg></svg>", ios_system_image: "ellipsis", android_icon: "more_horiz")
      app.account_supplier = ->(_view) { "acme" }
    end
    KeystoneUi::App.stub(:configuration, areas ? app : KeystoneUi::App.configuration) do
      KeystoneUi::App.hide_turned_off_groups(navigation) if areas
      KeystoneUi.stub(:configuration, navigation) { get "/pages/more", params: { tab: "quotes" } }
    end
  end
end
