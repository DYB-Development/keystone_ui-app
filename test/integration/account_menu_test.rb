# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class AccountMenuTest < ActionDispatch::IntegrationTest
  test "on desktop the avatar opens a dropdown of the account links the person may see" do
    get_with_account do |config|
      config.account_link(label: "Settings", href: "/settings", permitted: ->(_view) { true })
    end

    assert_select ".ks-app-account-menu .ks-nav-dropdown-menu a[href='/settings']", text: "Settings"
  end

  test "an account link the person may not see is left out of the dropdown" do
    get_with_account do |config|
      config.account_link(label: "Billing", href: "/billing", permitted: ->(_view) { false })
      config.account_link(label: "Settings", href: "/settings", permitted: ->(_view) { true })
    end

    assert_select ".ks-app-account-menu a[href='/billing']", count: 0
  end

  test "an account link marked as signing out is a button that sends DELETE to its address" do
    get_with_account do |config|
      config.account_link(label: "Sign out", href: "/sign_out", permitted: ->(_view) { true }, sign_out: true)
    end

    assert_select ".ks-app-account-menu form[action='/sign_out'] input[name='_method'][value='delete']"
  end

  test "with no picture the avatar on the dropdown shows the first letter of the person's name" do
    get_with_account do |config|
      config.account_link(label: "Settings", href: "/settings", permitted: ->(_view) { true })
      config.person_supplier = ->(_view) { { name: "ada Lovelace", email: "ada@example.com" } }
    end

    assert_select ".ks-app-account-menu .ks-nav-dropdown-trigger .ks-app-avatar", text: "A"
  end

  test "with a picture the avatar on the dropdown shows it" do
    get_with_account do |config|
      config.account_link(label: "Settings", href: "/settings", permitted: ->(_view) { true })
      config.person_supplier = ->(_view) { { name: "Ada", email: "ada@example.com", avatar_url: "/ada.png" } }
    end

    assert_select ".ks-app-account-menu .ks-nav-dropdown-trigger .ks-app-avatar img[src='/ada.png']"
  end

  test "once the app declares account links, the account menu takes the place of the menus it passes to the frame" do
    get_with_account do |config|
      config.account_link(label: "Settings", href: "/settings", permitted: ->(_view) { true })
    end

    assert_select "#menus", count: 0
  end

  test "when the app supplies the person's accounts, desktop shows an account switcher named after the current account" do
    get_with_account do |config|
      config.account_link(label: "Settings", href: "/settings", permitted: ->(_view) { true })
      config.accounts_supplier = ->(_view) { [ { name: "Acme", href: "/accounts/acme/switch", current: false }, { name: "Globex", href: "/accounts/globex/switch", current: true } ] }
    end

    assert_select ".ks-app-account-switcher .ks-nav-dropdown-trigger", text: "Globex"
  end

  test "choosing another account in the switcher sends PATCH to that account's address" do
    get_with_account do |config|
      config.account_link(label: "Settings", href: "/settings", permitted: ->(_view) { true })
      config.accounts_supplier = ->(_view) { [ { name: "Acme", href: "/accounts/acme/switch", current: false }, { name: "Globex", href: "/accounts/globex/switch", current: true } ] }
    end

    assert_select ".ks-app-account-switcher form[action='/accounts/acme/switch'] input[name='_method'][value='patch']"
  end

  test "when the app supplies notifications, desktop shows a bell with the unread count that opens the notifications page" do
    get_with_account do |config|
      config.account_link(label: "Settings", href: "/settings", permitted: ->(_view) { true })
      config.notifications(href: ->(_view) { "/notifications" }, unread_count: ->(_view) { 4 })
    end

    assert_select ".ks-app-account-menu a.ks-app-notifications-bell[href='/notifications'] .ks-badge", text: "4"
  end

  private

  def get_with_account(path = "/pages/plain", &declare)
    app = KeystoneUi::App::Configuration.new
    declare.call(app)
    KeystoneUi::App.stub(:configuration, app) { get path }
  end
end
