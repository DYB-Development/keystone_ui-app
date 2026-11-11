# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class AccountPageTest < ActionDispatch::IntegrationTest
  test "an app draws the Account page in one of its own pages with one call, showing the person's name" do
    get_account_page do |config|
      config.person_supplier = ->(_view) { { name: "Ada Lovelace", email: "ada@example.com" } }
    end

    assert_select "main .ks-app-account-person", text: /Ada Lovelace/
  end

  private

  def get_account_page(headers: {}, &declare)
    app = KeystoneUi::App::Configuration.new
    declare.call(app)
    KeystoneUi::App.stub(:configuration, app) { get "/pages/account", headers: headers }
  end
end
