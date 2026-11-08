require "test_helper"

class KeystoneUi::AppTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert KeystoneUi::App::VERSION
  end

  test "configure hands the app the configuration its bottom tabs are read from" do
    KeystoneUi::App.configure { |config| assert_same KeystoneUi::App.configuration, config }
  end
end
