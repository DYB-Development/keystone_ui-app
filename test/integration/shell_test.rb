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
end
