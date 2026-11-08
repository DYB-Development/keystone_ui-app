# frozen_string_literal: true

require "test_helper"

class NativeSubmitButtonTest < ActionDispatch::IntegrationTest
  NATIVE_APP = { "User-Agent" => "Hotwire Native iOS; Turbo Native iOS" }.freeze

  test "a form marked for the native nav bar connects to the native submit button" do
    get "/pages/native_form", headers: NATIVE_APP

    assert_select "form[data-controller='bridge--form']"
  end

  test "a form marked for the native nav bar tells the native submit button when a submit starts and ends" do
    get "/pages/native_form", headers: NATIVE_APP

    assert_select "form[data-action='turbo:submit-start->bridge--form#submitStart turbo:submit-end->bridge--form#submitEnd']"
  end
end
