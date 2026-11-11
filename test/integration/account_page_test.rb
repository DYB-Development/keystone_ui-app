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

  test "the Account page shows the person's email" do
    get_account_page do |config|
      config.person_supplier = ->(_view) { { name: "Ada Lovelace", email: "ada@example.com" } }
    end

    assert_select "main .ks-app-account-person", text: /ada@example.com/
  end

  test "the Account page lists every account and marks the current one" do
    get_account_page do |config|
      config.accounts_supplier = ->(_view) { [ { name: "Acme", href: "/accounts/acme/switch", current: false }, { name: "Globex", href: "/accounts/globex/switch", current: true } ] }
    end

    assert_select "main .ks-app-account-accounts [aria-current='true']", text: /Globex/
  end

  private

  def get_account_page(headers: {}, &declare)
    app = KeystoneUi::App::Configuration.new
    declare.call(app)
    KeystoneUi::App.stub(:configuration, app) { get "/pages/account", headers: headers }
  end
end
