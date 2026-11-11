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

  private

  def get_with_account(path = "/pages/plain", &declare)
    app = KeystoneUi::App::Configuration.new
    declare.call(app)
    KeystoneUi::App.stub(:configuration, app) { get path }
  end
end
