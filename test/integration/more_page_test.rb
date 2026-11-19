# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class MorePageTest < ActionDispatch::IntegrationTest
  test "an app draws the More page in one of its own pages with one call" do
    get "/pages/more"

    assert_select "main a[href='/pages/plain?tab=quotes']", text: "Quotes"
  end

  test "each group outside every area is one row labelled with the group's name that expands to list its pages" do
    get "/pages/more"

    assert_equal [ "Quotes", "Orders" ], links_in_group("Sales")
  end

  test "a page the person may not open is left off the More page" do
    get "/pages/more"

    assert_select "main a", text: "Refunds", count: 0
  end

  test "a group holding no page the person may open is left off the More page" do
    get_more_page do |navigation|
      navigation.navigation_group("Admin") do |group|
        group.tab(:audit, label: "Audit", href: "/pages/plain?tab=audit", permitted: ->(_view) { false })
      end
    end

    assert_equal [], more_rows.select { |row| row.first == "Admin" }
  end

  test "groups follow the order the person saved for their desktop menu" do
    get_more_page(saved_order: [ { "group" => "Billing" }, { "group" => "Sales" } ]) do |navigation|
      navigation.navigation_group("Sales") do |group|
        group.tab(:quotes, label: "Quotes", href: "/pages/plain?tab=quotes", permitted: ->(_view) { true })
      end
      navigation.navigation_group("Billing") do |group|
        group.tab(:invoices, label: "Invoices", href: "/pages/plain?tab=invoices", permitted: ->(_view) { true })
      end
    end

    assert_equal [ "Billing", "Sales" ], more_rows.map(&:first)
  end

  test "pages inside a group follow the order the person saved for their desktop menu" do
    get_more_page(saved_order: [ { "group" => "Sales", "tabs" => [ "orders", "quotes" ] } ]) do |navigation|
      navigation.navigation_group("Sales") do |group|
        group.tab(:quotes, label: "Quotes", href: "/pages/plain?tab=quotes", permitted: ->(_view) { true })
        group.tab(:orders, label: "Orders", href: "/pages/plain?tab=orders", permitted: ->(_view) { true })
      end
    end

    assert_equal [ "Orders", "Quotes" ], links_in_group("Sales")
  end

  test "a page declared outside any group is a single row with no group heading" do
    get_more_page do |navigation|
      navigation.navigation_tab(:inbox, label: "Inbox", href: "/pages/plain?tab=inbox", permitted: ->(_view) { true })
    end

    assert_equal [ [], [ "Inbox" ] ], [ more_rows.map(&:first) & [ "Inbox" ], css_select("main a").map { |link| link.text.strip } & [ "Inbox" ] ]
  end

  test "inside the native app the More page is drawn as an ordinary web page" do
    get "/pages/more", headers: { "User-Agent" => "Hotwire Native iOS; Turbo Native iOS" }

    assert_equal [ "Quotes", "Orders" ], links_in_group("Sales")
  end

  test "the More page has a field at its top for finding a page by name" do
    get "/pages/more"

    assert_select "main form[method=get] input[name=find]"
  end

  test "finding leaves only the pages whose label contains the typed text, ignoring letter case" do
    get_more_page(find: "ORD") { |navigation| sales_and_billing(navigation) }

    assert_equal [ [ "Sales", [ "Orders" ] ] ], listed_groups
  end

  test "typing a group's name shows that group with all its pages" do
    get_more_page(find: "sales") { |navigation| sales_and_billing(navigation) }

    assert_equal [ [ "Sales", [ "Quotes", "Orders" ] ] ], listed_groups
  end

  test "a group with no page left after finding is hidden along with its label" do
    get_more_page(find: "invo") { |navigation| sales_and_billing(navigation) }

    assert_equal [ "Billing" ], listed_groups.map(&:first)
  end

  test "clearing the field shows every group and page again" do
    get_more_page(find: "") { |navigation| sales_and_billing(navigation) }

    assert_equal [ [ "Sales", [ "Quotes", "Orders" ] ], [ "Billing", [ "Invoices" ] ] ], listed_groups
  end

  test "when nothing matches the More page says that no page matches" do
    get_more_page(find: "payroll") { |navigation| sales_and_billing(navigation) }

    assert_select "main", text: /No page matches/
  end

  test "inside the native app the find field narrows the pages the same way" do
    navigation = KeystoneUi::Configuration.new
    sales_and_billing(navigation)
    KeystoneUi.stub(:configuration, navigation) do
      get "/pages/more", params: { find: "ord" }, headers: { "User-Agent" => "Hotwire Native iOS; Turbo Native iOS" }
    end

    assert_equal [ true, [ [ "Sales", [ "Orders" ] ] ] ], [ css_select("main input[name=find]").any?, listed_groups ]
  end

  test "an area that is on gets one collapsed row labelled with its name, linking to the page its tab opens and expanding to its pages" do
    get_more_page_with_areas { |app| app.app_area(**selling_area(opens: :orders)) }

    assert_equal [ [ "Selling", "/pages/plain?tab=orders", false, [ "Quotes", "Orders" ] ], [ "Billing", nil, false, [ "Invoices" ] ] ], more_rows
  end

  test "an area the account has turned off has no row" do
    get_more_page_with_areas(selling_on: false) { |app| app.app_area(**selling_area) }

    assert_equal [ "Billing" ], more_rows.map(&:first)
  end

  test "typing in the find field expands each row that still holds a matching page" do
    get_more_page_with_areas(find: "o") { |app| app.app_area(**selling_area) }

    assert_equal [ [ "Selling", true ], [ "Billing", true ] ], more_rows.map { |row| [ row[0], row[2] ] }
  end

  test "inside the iOS app each row is an expandable details element that needs no script" do
    navigation = KeystoneUi::Configuration.new
    sales_and_billing(navigation)
    KeystoneUi.stub(:configuration, navigation) { get "/pages/more", headers: { "User-Agent" => "Hotwire Native iOS; Turbo Native iOS" } }

    assert_equal [ [ "Sales", [ "Quotes", "Orders" ] ], [ "Billing", [ "Invoices" ] ] ], listed_groups
  end

  private

  def get_more_page_with_areas(selling_on: nil, find: nil)
    navigation = KeystoneUi::Configuration.new
    sales_and_billing(navigation)
    app = KeystoneUi::App::Configuration.new
    yield(app)
    app.account_supplier = ->(_view) { "acme" }
    KeystoneUi::App::AreaChoices.new(app, account: "acme").turn("Selling", on: selling_on) unless selling_on.nil?
    KeystoneUi::App.stub(:configuration, app) do
      KeystoneUi::App.hide_turned_off_groups(navigation)
      KeystoneUi.stub(:configuration, navigation) { get "/pages/more", params: { find: find }.compact }
    end
  end

  def selling_area(**options)
    { name: "Selling", description: "Quotes and orders", groups: [ "Sales" ], on_by_default: true, icon: "<svg></svg>", ios_system_image: "cart", android_icon: "cart", **options }
  end

  def more_rows
    css_select("main details").map do |row|
      summary = row.at_css("summary")
      [ summary.text.strip, summary.at_css("a")&.[]("href"), row.key?("open"), row.css(".ks-disclosure-body a").map { |link| link.text.strip } ]
    end
  end

  def sales_and_billing(navigation)
    navigation.navigation_group("Sales") do |group|
      group.tab(:quotes, label: "Quotes", href: "/pages/plain?tab=quotes", permitted: ->(_view) { true })
      group.tab(:orders, label: "Orders", href: "/pages/plain?tab=orders", permitted: ->(_view) { true })
    end
    navigation.navigation_group("Billing") do |group|
      group.tab(:invoices, label: "Invoices", href: "/pages/plain?tab=invoices", permitted: ->(_view) { true })
    end
  end

  def listed_groups
    more_rows.map { |label, _href, _open, pages| [ label, pages ] }
  end

  def get_more_page(saved_order: nil, find: nil)
    navigation = KeystoneUi::Configuration.new
    yield(navigation)
    navigation.preference_supplier = ->(_view, _key) { { value: { "order" => saved_order } } } if saved_order
    KeystoneUi.stub(:configuration, navigation) { get "/pages/more", params: { find: find }.compact }
  end

  def links_in_group(label)
    more_rows.find { |row| row.first == label }&.last || []
  end
end
