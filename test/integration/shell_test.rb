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
end
