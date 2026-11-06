# frozen_string_literal: true

require "test_helper"

class ShellTest < ActionDispatch::IntegrationTest
  test "a layout that calls the shell draws the page inside the main element" do
    get "/pages/plain"

    assert_select "html > body main", text: "Plain page"
  end

  test "the shell draws the app's head inside the head element" do
    get "/pages/plain"

    assert_select "html > head > title", text: "Dummy"
  end

  test "the shell draws the app's flash inside the header" do
    get "/pages/plain"

    assert_select "body > header #flash", text: "Saved"
  end

  test "the shell marks the page with the theme mode keystone_ui chooses for the person" do
    cookies["keystone_theme"] = "dark"

    get "/pages/plain"

    assert_select "html[data-theme=dark]"
  end

  test "in a browser the shell draws the app's logo in the navigation bar" do
    get "/pages/plain"

    assert_select "nav #logo", text: "Dummy logo"
  end

  test "in a browser the shell draws the app's menus in the navigation bar" do
    get "/pages/plain"

    assert_select "nav #menus", text: "Account menu"
  end

  test "in a browser the shell draws the app's footer at the end of the body" do
    get "/pages/plain"

    assert_select "body > #footer", text: "Dummy footer"
  end

  test "a page that asks for no footer is drawn without the app's footer" do
    get "/pages/no_footer"

    assert_select "#footer", count: 0
  end

  test "on a show page the shell draws the phone header with the page's title" do
    get "/pages/show"

    assert_select "header .ks-mobile-header-title", text: /Invoice/
  end
  test "on a show page the phone header links back to the page's back link" do
    get "/pages/show"

    assert_select "header a.ks-mobile-header-back[href='/pages/plain']"
  end
  test "on a show page the phone header shows the page's subtitle" do
    get "/pages/show"

    assert_select "header .ks-mobile-header-subtitle", text: "INV-1"
  end
end
