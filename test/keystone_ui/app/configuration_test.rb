# frozen_string_literal: true

require "test_helper"
require "keystone_ui/app/configuration"

class KeystoneUi::App::ConfigurationTest < ActiveSupport::TestCase
  test "a bottom tab records its label, address, icon, permission check and section" do
    permitted = ->(_view) { true }
    configuration = KeystoneUi::App::Configuration.new

    configuration.bottom_tab(label: "Sales", href: "/quotes", icon: "<svg></svg>", permitted: permitted, section: "Sales")

    assert_equal({ label: "Sales", href: "/quotes", icon: "<svg></svg>", permitted: permitted, section: "Sales", ios_system_image: nil, android_icon: nil }, configuration.bottom_tabs.first.to_h)
  end

  test "a bottom tab records its iOS system image and Android icon" do
    configuration = KeystoneUi::App::Configuration.new

    configuration.bottom_tab(label: "Sales", href: "/quotes", icon: "<svg></svg>", permitted: ->(_view) { true }, section: "Sales", ios_system_image: "cart", android_icon: "shopping_cart")

    assert_equal [ "cart", "shopping_cart" ], configuration.bottom_tabs.first.to_h.values_at(:ios_system_image, :android_icon)
  end

  test "an app area records its name, description, groups, default, tab icon, iOS image and Android icon" do
    configuration = KeystoneUi::App::Configuration.new

    configuration.app_area(name: "Selling", description: "Quotes and orders", groups: [ "Sales" ], on_by_default: true, icon: "<svg></svg>", ios_system_image: "cart", android_icon: "shopping_cart")

    assert_equal({ name: "Selling", description: "Quotes and orders", groups: [ "Sales" ], on_by_default: true, opens: nil, icon: "<svg></svg>", ios_system_image: "cart", android_icon: "shopping_cart" }, configuration.app_areas.first.to_h)
  end

  test "an app's screen rule records its patterns and properties" do
    configuration = KeystoneUi::App::Configuration.new

    configuration.native_rule(patterns: [ "/users/sign_in" ], properties: { context: "modal" })

    assert_equal [ { patterns: [ "/users/sign_in" ], properties: { context: "modal" } } ], configuration.native_rules
  end

  test "an app's native setting records its value under its name" do
    configuration = KeystoneUi::App::Configuration.new

    configuration.native_setting(:require_authentication, true)

    assert_equal({ require_authentication: true }, configuration.native_settings)
  end
end
