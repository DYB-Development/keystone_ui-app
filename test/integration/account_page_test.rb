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

  test "choosing another account on the Account page sends PATCH to that account's address" do
    get_account_page do |config|
      config.accounts_supplier = ->(_view) { [ { name: "Acme", href: "/accounts/acme/switch", current: false }, { name: "Globex", href: "/accounts/globex/switch", current: true } ] }
    end

    assert_select "main .ks-app-account-accounts form[action='/accounts/acme/switch'] input[name='_method'][value='patch']"
  end

  test "when the app supplies notifications, the Account page has a Notifications row showing the unread count" do
    get_account_page do |config|
      config.notifications(href: "/notifications", unread_count: 4)
    end

    assert_select "main a[href='/notifications'] .ks-badge", text: "4"
  end

  test "the Account page lists the account links the person may see, in the order the app declares them" do
    get_account_page do |config|
      config.account_link(label: "Settings", href: "/settings", permitted: ->(_view) { true })
      config.account_link(label: "Billing", href: "/billing", permitted: ->(_view) { false })
      config.account_link(label: "Profile", href: ->(_view) { "/profile" }, permitted: ->(_view) { true })
    end

    assert_equal [ "Settings", "Profile" ], css_select("main .ks-app-account-links a").map { |link| link.text.strip }
  end

  test "an account link marked as signing out is a button on the Account page that sends DELETE to its address" do
    get_account_page do |config|
      config.account_link(label: "Sign out", href: "/sign_out", permitted: ->(_view) { true }, sign_out: true)
    end

    assert_select "main .ks-app-account-links form[action='/sign_out'] input[name='_method'][value='delete']"
  end

  test "inside the native app the Account page is drawn as an ordinary web page" do
    get_account_page(headers: { "User-Agent" => "Hotwire Native iOS; Turbo Native iOS" }) do |config|
      config.account_link(label: "Settings", href: "/settings", permitted: ->(_view) { true })
    end

    assert_select "main .ks-app-account-links a[href='/settings']", text: "Settings"
  end

  private

  def get_account_page(headers: {}, &declare)
    app = KeystoneUi::App::Configuration.new
    declare.call(app)
    KeystoneUi::App.stub(:configuration, app) { get "/pages/account", headers: headers }
  end
end
