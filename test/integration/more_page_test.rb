# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class MorePageTest < ActionDispatch::IntegrationTest
  test "an app draws the More page in one of its own pages with one call" do
    get "/pages/more"

    assert_select "main a[href='/pages/plain?tab=quotes']", text: "Quotes"
  end

  test "each group's pages are listed under a heading with the group's label" do
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

    assert_select "main h2", text: "Admin", count: 0
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

    assert_equal [ "Billing", "Sales" ], css_select("main h2").map { |heading| heading.text.strip }
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

    assert_select "main h2", text: "Inbox", count: 0
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

  private

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
    css_select("main section").map { |section| [ section.at_css("h2").text.strip, section.css("a").map { |link| link.text.strip } ] }
  end

  def get_more_page(saved_order: nil, find: nil)
    navigation = KeystoneUi::Configuration.new
    yield(navigation)
    navigation.preference_supplier = ->(_view, _key) { { value: { "order" => saved_order } } } if saved_order
    KeystoneUi.stub(:configuration, navigation) { get "/pages/more", params: { find: find }.compact }
  end

  def links_in_group(label)
    group = css_select("main section").find { |section| section.at_css("h2")&.text&.strip == label }
    group ? group.css("a").map { |link| link.text.strip } : []
  end
end
