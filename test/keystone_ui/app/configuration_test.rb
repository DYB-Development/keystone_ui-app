# frozen_string_literal: true

require "test_helper"
require "keystone_ui/app/configuration"

class KeystoneUi::App::ConfigurationTest < ActiveSupport::TestCase
  test "a bottom tab records its label, address, icon, permission check and section" do
    permitted = ->(_view) { true }
    configuration = KeystoneUi::App::Configuration.new

    configuration.bottom_tab(label: "Sales", href: "/quotes", icon: "<svg></svg>", permitted: permitted, section: "Sales")

    assert_equal({ label: "Sales", href: "/quotes", icon: "<svg></svg>", permitted: permitted, section: "Sales" }, configuration.bottom_tabs.first.to_h)
  end
end
