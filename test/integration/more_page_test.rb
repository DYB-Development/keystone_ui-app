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

  private

  def get_more_page(saved_order: nil)
    navigation = KeystoneUi::Configuration.new
    yield(navigation)
    navigation.preference_supplier = ->(_view, _key) { { value: { "order" => saved_order } } } if saved_order
    KeystoneUi.stub(:configuration, navigation) { get "/pages/more" }
  end

  def links_in_group(label)
    group = css_select("main section").find { |section| section.at_css("h2")&.text&.strip == label }
    group ? group.css("a").map { |link| link.text.strip } : []
  end
end
