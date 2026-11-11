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

  private

  def get_with_account(path = "/pages/plain", &declare)
    app = KeystoneUi::App::Configuration.new
    declare.call(app)
    KeystoneUi::App.stub(:configuration, app) { get path }
  end
end
