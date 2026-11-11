# frozen_string_literal: true

require "test_helper"
require "minitest/mock"

class KeystoneUi::App::EngineTest < ActiveSupport::TestCase
  test "the shell check at boot refuses the app's own bottom tabs when one is declared wrong" do
    configuration = KeystoneUi::App::Configuration.new
    configuration.bottom_tab(label: "", href: "/quotes", icon: "<svg></svg>", permitted: ->(_view) { true }, section: nil, ios_system_image: "cart", android_icon: "shopping_cart")

    KeystoneUi::App.stub(:configuration, configuration) do
      assert_raises(KeystoneUi::App::ShellCheck::Error) { KeystoneUi::App::Engine.check_shell }
    end
  end

  test "the shell check at boot refuses the app's own areas when one names an undeclared group" do
    configuration = KeystoneUi::App::Configuration.new
    configuration.app_area(name: "Selling", description: "Quotes and orders", groups: [ "Billing" ], on_by_default: true, icon: "<svg></svg>", ios_system_image: "cart", android_icon: "shopping_cart")

    KeystoneUi::App.stub(:configuration, configuration) do
      assert_raises(KeystoneUi::App::ShellCheck::Error) { KeystoneUi::App::Engine.check_shell }
    end
  end
end
