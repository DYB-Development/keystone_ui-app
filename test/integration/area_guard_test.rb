# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class AreaGuardTest < ActionDispatch::IntegrationTest
  test "opening a page whose area is off for the account shows a page saying the area is off" do
    get_selling(on: false)

    assert_select "main", text: /Selling is turned off/
  end

  test "a JSON request to a page whose area is off gets a forbidden response" do
    get_selling(on: false, format: :json)

    assert_equal [ 403, "" ], [ response.status, response.body ]
  end

  test "a page whose area is on opens as usual" do
    get_selling(on: true)

    assert_equal "Selling page", response.body
  end

  test "the area is off page links to the areas settings for a person allowed to change them" do
    get_selling(on: false, settings: ->(_view) { true })

    assert_select "main a[href='/settings/areas']"
  end

  test "the area is off page has no settings link for a person not allowed to change areas" do
    get_selling(on: false, settings: ->(_view) { false })

    assert_select "main a[href='/settings/areas']", count: 0
  end

  test "a person who fails an area's check sees a page saying the area is not available to them yet" do
    get_selling(on: true, available: ->(_view) { false })

    assert_select "main", text: /Selling is not available to you yet/
  end

  test "the not available yet page is not the area is off page" do
    get_selling(on: true, available: ->(_view) { false })

    assert_select "main", text: /turned off/, count: 0
  end

  private

  def get_selling(on:, format: nil, available: nil, settings: nil)
    navigation = KeystoneUi::Configuration.new
    navigation.navigation_group("Sales") { |group| group.tab(:quotes, label: "Quotes", href: "/selling", permitted: ->(_view) { true }) }
    app = KeystoneUi::App::Configuration.new
    app.app_area(name: "Selling", description: "Quotes", groups: [ "Sales" ], on_by_default: true, icon: "<svg></svg>", ios_system_image: "cart", android_icon: "cart", available: available)
    app.account_supplier = ->(_view) { "acme" }
    app.areas_settings(href: "/settings/areas", permitted: settings) if settings
    KeystoneUi::App::AreaChoices.new(app, account: "acme").turn("Selling", on: on) unless on.nil?
    KeystoneUi::App.stub(:configuration, app) do
      KeystoneUi.stub(:configuration, navigation) { get "/selling", headers: (format == :json ? { "Accept" => "application/json" } : {}) }
    end
  end
end
