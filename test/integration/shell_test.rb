# frozen_string_literal: true

require "test_helper"

class ShellTest < ActionDispatch::IntegrationTest
  NATIVE_APP = { "User-Agent" => "Hotwire Native iOS; Turbo Native iOS" }.freeze

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
  test "on a form page the shell draws the phone header with the page's title" do
    get "/pages/form"

    assert_select "header .ks-mobile-header-title", text: /Edit/
  end
  test "on a form page the phone header shows the page's subtitle" do
    get "/pages/form"

    assert_select "header .ks-mobile-header-subtitle", text: "INV-1"
  end
  test "inside the native app the shell draws no web navigation bar" do
    get "/pages/plain", headers: NATIVE_APP

    assert_select "#logo", count: 0
  end
  test "inside the native app the shell draws no phone header" do
    get "/pages/show", headers: NATIVE_APP

    assert_select ".ks-mobile-header-title", count: 0
  end
  test "inside the native app the shell draws no footer" do
    get "/pages/plain", headers: NATIVE_APP

    assert_select "#footer", count: 0
  end
  test "in a browser the page can be pinch-zoomed" do
    get "/pages/plain"

    assert_select "head meta[name=viewport][content=?]", "width=device-width, initial-scale=1"
  end
  test "inside the native app the page cannot be pinch-zoomed" do
    get "/pages/plain", headers: NATIVE_APP

    assert_select "head meta[name=viewport][content=?]", "width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=0"
  end
  test "inside the native app the shell marks the html element for keystone_ui's native variants" do
    get "/pages/plain", headers: NATIVE_APP

    assert_select "html.hotwire-native"
  end
  test "the shell marks the page with the current locale" do
    get "/pages/plain"

    assert_select "html[lang=en]"
  end
  test "the page's body carries the attributes the app passes for it" do
    get "/pages/plain"

    assert_select "body[data-controller=trail][data-trail-url-value='/pages/plain']"
  end
  test "on a phone browser the shell draws the app's phone menus in the header" do
    get "/pages/plain"

    assert_select "header div[class~='lg:hidden'] #phone-menus", text: "Phone menu"
  end
  test "on a show page the shell draws the app's phone menus in the header" do
    get "/pages/show"

    assert_select "header div[class~='lg:hidden'] #phone-menus", text: "Phone menu"
  end
  test "on a form page the shell draws the app's phone menus in the header" do
    get "/pages/form"

    assert_select "header div[class~='lg:hidden'] #phone-menus", text: "Phone menu"
  end
  test "inside the native app the shell draws no phone menus" do
    get "/pages/plain", headers: NATIVE_APP

    assert_select "#phone-menus", count: 0
  end
end
