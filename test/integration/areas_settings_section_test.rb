# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class AreasSettingsSectionTest < ActionDispatch::IntegrationTest
  test "the areas section lists each area with its name, its description and a button to turn it off" do
    get_section { |app| app.app_area(**area(name: "Selling", description: "Quotes and orders")) }

    assert_equal [ [ "Selling", "Quotes and orders", "Turn off" ] ], listed_areas
  end

  test "the areas section lists only areas holding a page the person may open" do
    get_section do |app|
      app.app_area(**area(name: "Selling"))
      app.app_area(**area(name: "Admin", groups: [ "Admin" ]))
    end

    assert_equal [ "Selling" ], listed_areas.map(&:first)
  end

  test "an area whose check fails for the person shows as not available yet, with no button" do
    get_section { |app| app.app_area(**area(name: "Selling", available: ->(_view) { false })) }

    assert_equal [ [ "Selling", "Not available yet", nil ] ], css_select("[data-area]").map { |row| [ row.at_css("[data-area-name]").text.strip, row.at_css("[data-area-status]")&.text&.strip, row.at_css("button")&.text ] }
  end

  private

  def get_section(&declare)
    navigation = KeystoneUi::Configuration.new
    navigation.navigation_group("Sales") { |group| group.tab(:quotes, label: "Quotes", href: "/pages/plain?tab=quotes", permitted: ->(_view) { true }) }
    navigation.navigation_group("Admin") { |group| group.tab(:audit, label: "Audit", href: "/pages/plain?tab=audit", permitted: ->(_view) { false }) }
    app = KeystoneUi::App::Configuration.new
    app.account_supplier = ->(_view) { "acme" }
    declare.call(app)
    KeystoneUi::App.stub(:configuration, app) do
      KeystoneUi.stub(:configuration, navigation) { get "/pages/areas_settings" }
    end
  end

  def area(name:, description: "#{name} pages", groups: [ "Sales" ], **options)
    { name: name, description: description, groups: groups, on_by_default: true, icon: "<svg></svg>", ios_system_image: "square", android_icon: "square", **options }
  end

  def listed_areas
    css_select("[data-area]").map do |row|
      [ row.at_css("[data-area-name]").text.strip, row.at_css("[data-area-description]").text.strip, row.at_css("button")&.text&.strip ]
    end
  end
end
