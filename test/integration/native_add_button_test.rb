# frozen_string_literal: true

require "test_helper"

class NativeAddButtonTest < ActionDispatch::IntegrationTest
  NATIVE_APP = { "User-Agent" => "Hotwire Native iOS; Turbo Native iOS" }.freeze
  ADD_BUTTON = "[data-controller='bridge--add-button']"

  def add_button
    css_select(ADD_BUTTON).first
  end

  test "inside the native app a page whose header has an add action sends the action's address to the native add button" do
    get "/pages/add", headers: NATIVE_APP

    assert_equal "/quotes/new", add_button["data-bridge--add-button-url-value"]
  end

  test "inside the native app the native add button carries the add action's label" do
    get "/pages/add", headers: NATIVE_APP

    assert_equal "New quote", add_button["data-bridge--add-button-label-value"]
  end

  test "inside the native app the native add button carries the method of an add action marked to post" do
    get "/pages/post_add", headers: NATIVE_APP

    assert_equal "post", add_button["data-bridge--add-button-method-value"]
  end

  test "inside the native app a page whose header has no add action draws no native add button" do
    get "/pages/header", headers: NATIVE_APP

    assert_select ADD_BUTTON, count: 0
  end

  test "in a browser a page whose header has an add action draws no native add button" do
    get "/pages/add"

    assert_select ADD_BUTTON, count: 0
  end
end
