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

  test "an area that is off by default gets no tab" do
    get_with_areas "/pages/plain" do |config|
      config.app_area(**area(name: "Selling", groups: [ "Sales" ], on_by_default: false))
    end

    assert_equal [ "Home" ], tab_labels
  end

  test "an area holding no page the person may open gets no tab" do
    get_with_areas "/pages/plain" do |config|
      config.app_area(**area(name: "Admin", groups: [ "Admin" ]))
    end

    assert_equal [ "Home" ], tab_labels
  end

  test "area tabs follow the person's saved group order, each area in the place of its first group" do
    get_with_areas "/pages/plain", saved_order: [ { "group" => "Billing" }, { "group" => "Sales" } ] do |config|
      config.app_area(**area(name: "Selling", groups: [ "Sales" ]))
      config.app_area(**area(name: "Back office", groups: [ "Stock", "Billing" ]))
    end

    assert_equal [ "Home", "Back office", "Selling" ], tab_labels
  end

  test "with no saved group order, area tabs follow the order the app declares the areas" do
    get_with_areas "/pages/plain" do |config|
      config.app_area(**area(name: "Back office", groups: [ "Stock", "Billing" ]))
      config.app_area(**area(name: "Selling", groups: [ "Sales" ]))
    end

    assert_equal [ "Home", "Back office", "Selling" ], tab_labels
  end

  test "an area's tab opens the page the area names when the person may open it" do
    get_with_areas "/pages/plain" do |config|
      config.app_area(**area(name: "Selling", groups: [ "Sales" ], opens: :orders))
    end

    assert_equal "/pages/plain?tab=orders", tab_href("Selling")
  end

  test "an area's tab opens the first page in the area the person may open when they may not open the page it names" do
    get_with_areas "/pages/plain" do |config|
      config.app_area(**area(name: "Selling", groups: [ "Sales" ], opens: :refunds))
    end

    assert_equal "/pages/plain?tab=quotes", tab_href("Selling")
  end

  test "an area's tab is marked current on a page in any of the area's groups" do
    get_with_areas "/pages/plain?tab=invoices" do |config|
      config.app_area(**area(name: "Back office", groups: [ "Stock", "Billing" ]))
    end

    assert_select "nav.ks-bottom-nav a.active .ks-bottom-nav-label", text: "Back office"
  end

  test "when the app declares a More page and the person may open a page no tab opens, the bar ends with a More tab" do
    get_with_areas "/pages/plain" do |config|
      config.app_area(**area(name: "Selling", groups: [ "Sales" ]))
      config.more_page(**more_page)
    end

    assert_equal [ "Home", "Selling", "More" ], tab_labels
  end

  test "when every page the person may open has a tab, the bar has no More tab" do
    single_page = KeystoneUi::Configuration.new
    single_page.navigation_group("Sales") { |group| group.tab(:quotes, label: "Quotes", href: "/pages/plain?tab=quotes", permitted: ->(_view) { true }) }

    get_with_areas "/pages/plain", navigation: single_page do |config|
      config.app_area(**area(name: "Selling", groups: [ "Sales" ]))
      config.more_page(**more_page)
    end

    assert_equal [ "Home", "Selling" ], tab_labels
  end

  test "the More tab is marked current while the More page is open" do
    get_with_areas "/pages/show" do |config|
      config.app_area(**area(name: "Selling", groups: [ "Sales" ]))
      config.more_page(**more_page)
    end

    assert_select "nav.ks-bottom-nav a.active .ks-bottom-nav-label", text: "More"
  end

  test "a bar with a More tab holds no more than five tabs, leaving out the areas that come last" do
    get_with_areas "/pages/plain" do |config|
      declare_two_more_fixed_tabs(config)
      config.app_area(**area(name: "Selling", groups: [ "Sales" ]))
      config.app_area(**area(name: "Goods", groups: [ "Stock" ]))
      config.app_area(**area(name: "Money", groups: [ "Billing" ]))
      config.more_page(**more_page)
    end

    assert_equal [ "Home", "Inbox", "Calendar", "Selling", "More" ], tab_labels
  end

  test "a bar with no More page holds no more than five tabs, leaving out the areas that come last" do
    get_with_areas "/pages/plain" do |config|
      declare_two_more_fixed_tabs(config)
      config.app_area(**area(name: "Selling", groups: [ "Sales" ]))
      config.app_area(**area(name: "Goods", groups: [ "Stock" ]))
      config.app_area(**area(name: "Money", groups: [ "Billing" ]))
    end

    assert_equal [ "Home", "Inbox", "Calendar", "Selling", "Goods" ], tab_labels
  end

  test "an area's tab whose icon is drawn by the page shows that icon" do
    get_with_areas "/pages/plain" do |config|
      config.app_area(**area(name: "Selling", groups: [ "Sales" ], icon: ->(view) { view.tag.svg(id: "selling-icon") }))
    end

    assert_select "nav.ks-bottom-nav a svg#selling-icon"
  end

  private

  def get_with_areas(path, saved_order: nil, navigation: navigation(saved_order), &declare)
    app = KeystoneUi::App::Configuration.new
    app.bottom_tab(label: "Home", href: "/pages/plain", icon: "<svg></svg>", permitted: ->(_view) { true }, section: nil, ios_system_image: "house", android_icon: "home")
    declare.call(app)
    KeystoneUi.stub(:configuration, navigation) do
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

  def area(name:, groups:, on_by_default: true, opens: nil, icon: "<svg></svg>")
    { name: name, description: "#{name} pages", groups: groups, on_by_default: on_by_default, opens: opens, icon: icon, ios_system_image: "square", android_icon: "square" }
  end

  def declare_two_more_fixed_tabs(config)
    config.bottom_tab(label: "Inbox", href: "/pages/plain?tab=inbox", icon: "<svg></svg>", permitted: ->(_view) { true }, section: nil, ios_system_image: "tray", android_icon: "inbox")
    config.bottom_tab(label: "Calendar", href: "/pages/plain?tab=calendar", icon: "<svg></svg>", permitted: ->(_view) { true }, section: nil, ios_system_image: "calendar", android_icon: "event")
  end

  def more_page
    { href: "/pages/show", icon: "<svg></svg>", ios_system_image: "ellipsis", android_icon: "more_horiz" }
  end

  def tab_href(label)
    css_select("nav.ks-bottom-nav a").find { |link| link.at_css(".ks-bottom-nav-label").text.strip == label }["href"]
  end

  def tab_labels
    css_select("nav.ks-bottom-nav a .ks-bottom-nav-label").map { |label| label.text.strip }
  end
end
