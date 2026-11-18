# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class AreaPageTest < ActionDispatch::IntegrationTest
  test "an area page lists the pages of each of the area's groups under the group's heading" do
    get_area_page("Selling") do |config|
      config.app_area(**area(name: "Selling", groups: [ "Sales", "Billing" ], opens: :invoices))
    end

    assert_equal [ [ "Sales", [ "Quotes", "Orders" ] ] ], listed_groups
  end

  test "the page the area's tab opens is left out of the list" do
    get_area_page("Selling") do |config|
      config.app_area(**area(name: "Selling", groups: [ "Sales" ], opens: :orders))
    end

    assert_equal [ [ "Sales", [ "Quotes" ] ] ], listed_groups
  end

  test "an area that names no page to open leaves out its first page, which its tab opens" do
    get_area_page("Selling") do |config|
      config.app_area(**area(name: "Selling", groups: [ "Sales" ]))
    end

    assert_equal [ [ "Sales", [ "Orders" ] ] ], listed_groups
  end

  test "pages follow the order the person saved for their navigation" do
    get_area_page("Selling", saved_order: [ { "group" => "Billing" }, { "group" => "Sales", "tabs" => [ "orders", "quotes" ] } ]) do |config|
      config.app_area(**area(name: "Selling", groups: [ "Sales", "Billing", "Stock" ], opens: :items))
    end

    assert_equal [ [ "Billing", [ "Invoices" ] ], [ "Sales", [ "Orders", "Quotes" ] ] ], listed_groups
  end

  test "each row on an area page opens its page" do
    get_area_page("Selling") do |config|
      config.app_area(**area(name: "Selling", groups: [ "Sales" ], opens: :quotes))
    end

    assert_select "main a[href='/pages/plain?tab=orders']", text: "Orders"
  end

  test "naming an area that is not declared raises an error naming it" do
    error = assert_raises(ActionView::Template::Error) do
      get_area_page("Selling") { |_config| }
    end

    assert_match(/Selling/, error.cause.message)
  end

  private

  def get_area_page(name, saved_order: nil, &declare)
    app = KeystoneUi::App::Configuration.new
    declare.call(app)
    KeystoneUi.stub(:configuration, navigation(saved_order)) do
      KeystoneUi::App.stub(:configuration, app) { get "/pages/area", params: { area: name } }
    end
  end

  def navigation(saved_order)
    configuration = KeystoneUi::Configuration.new
    configuration.navigation_group("Sales") do |group|
      group.tab(:quotes, label: "Quotes", href: "/pages/plain?tab=quotes", permitted: ->(_view) { true })
      group.tab(:refunds, label: "Refunds", href: "/pages/plain?tab=refunds", permitted: ->(_view) { false })
      group.tab(:orders, label: "Orders", href: "/pages/plain?tab=orders", permitted: ->(_view) { true })
    end
    configuration.navigation_group("Stock") do |group|
      group.tab(:items, label: "Items", href: "/pages/plain?tab=items", permitted: ->(_view) { true })
    end
    configuration.navigation_group("Billing") do |group|
      group.tab(:invoices, label: "Invoices", href: "/pages/plain?tab=invoices", permitted: ->(_view) { true })
    end
    configuration.preference_supplier = ->(_view, _key) { { value: { "order" => saved_order } } } if saved_order
    configuration
  end

  def area(name:, groups:, opens: nil)
    { name: name, description: "#{name} pages", groups: groups, on_by_default: true, opens: opens, icon: "<svg></svg>", ios_system_image: "square", android_icon: "square" }
  end

  def listed_groups
    css_select("main section").map do |section|
      [ section.at_css("h2").text.strip, section.css("a").map { |link| link.text.strip } ]
    end
  end
end
