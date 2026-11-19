# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class TurnedOffAreasTest < ActionDispatch::IntegrationTest
  test "the desktop menu leaves out the groups of an area the account has turned off" do
    get_with_selling("/pages/plain", on: false)

    assert_select "nav.top-nav a.ks-nav-item", text: "Quotes", count: 0
  end

  test "the More page leaves out the groups of an area the account has turned off" do
    get_with_selling("/pages/more", on: false)

    assert_select "main a", text: "Quotes", count: 0
  end

  test "the phone group menu is not drawn on a page in an area the account has turned off" do
    get_with_selling("/pages/plain?tab=quotes", on: false)

    assert_select "header .ks-nav-dropdown-menu a", text: "Quotes", count: 0
  end

  private

  def get_with_selling(path, on:)
    navigation = KeystoneUi::Configuration.new
    navigation.navigation_group("Sales") { |group| group.tab(:quotes, label: "Quotes", href: "/pages/plain?tab=quotes", permitted: ->(_view) { true }) }
    navigation.navigation_group("Billing") { |group| group.tab(:invoices, label: "Invoices", href: "/pages/plain?tab=invoices", permitted: ->(_view) { true }) }
    navigation.current_tab_supplier = ->(view) { view.params[:tab]&.to_sym }
    app = KeystoneUi::App::Configuration.new
    app.app_area(name: "Selling", description: "Quotes", groups: [ "Sales" ], on_by_default: true, icon: "<svg></svg>", ios_system_image: "cart", android_icon: "cart")
    app.more_page(href: "/pages/more", icon: "<svg></svg>", ios_system_image: "ellipsis", android_icon: "more_horiz")
    app.account_supplier = ->(_view) { "acme" }
    KeystoneUi::App::AreaChoices.new(app, account: "acme").turn("Selling", on: on)
    KeystoneUi::App.stub(:configuration, app) do
      KeystoneUi::App.hide_turned_off_groups(navigation)
      KeystoneUi.stub(:configuration, navigation) { get path }
    end
  end
end
