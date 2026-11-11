# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class AreaTabsTest < ActionDispatch::IntegrationTest
  test "an area that is on by default gets a tab named after it, after the fixed tabs" do
    get_with_areas "/pages/plain" do |config|
      config.app_area(**area(name: "Selling", groups: [ "Sales" ]))
    end

    assert_equal [ "Home", "Selling" ], tab_labels
  end

  private

  def get_with_areas(path, saved_order: nil, &declare)
    app = KeystoneUi::App::Configuration.new
    app.bottom_tab(label: "Home", href: "/pages/plain", icon: "<svg></svg>", permitted: ->(_view) { true }, section: nil, ios_system_image: "house", android_icon: "home")
    declare.call(app)
    KeystoneUi.stub(:configuration, navigation(saved_order)) do
      KeystoneUi::App.stub(:configuration, app) { get path }
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
    configuration.navigation_group("Admin") do |group|
      group.tab(:audit, label: "Audit", href: "/pages/plain?tab=audit", permitted: ->(_view) { false })
    end
    configuration.current_tab_supplier = ->(view) { view.params[:tab]&.to_sym }
    configuration.preference_supplier = ->(_view, _key) { { value: { "order" => saved_order } } } if saved_order
    configuration
  end

  def area(name:, groups:, on_by_default: true, opens: nil)
    { name: name, description: "#{name} pages", groups: groups, on_by_default: on_by_default, opens: opens, icon: "<svg></svg>", ios_system_image: "square", android_icon: "square" }
  end

  def tab_labels
    css_select("nav.ks-bottom-nav a .ks-bottom-nav-label").map { |label| label.text.strip }
  end
end
