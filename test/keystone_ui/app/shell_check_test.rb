# frozen_string_literal: true

require "test_helper"
require "keystone_ui/app/shell_check"

class KeystoneUi::App::ShellCheckTest < ActiveSupport::TestCase
  test "a bottom tab with no label is refused, named by its position" do
    error = assert_raises(KeystoneUi::App::ShellCheck::Error) { check(bottom_tabs: [ tab, tab(label: "") ]) }

    assert_equal "Bottom tab 2 has no label.", error.message
  end

  test "a bottom tab with no address is refused, named by its label" do
    error = assert_raises(KeystoneUi::App::ShellCheck::Error) { check(bottom_tabs: [ tab(href: nil) ]) }

    assert_equal "The Sales bottom tab has no address.", error.message
  end

  test "a bottom tab with no icon is refused, named by its label" do
    error = assert_raises(KeystoneUi::App::ShellCheck::Error) { check(bottom_tabs: [ tab(icon: nil) ]) }

    assert_equal "The Sales bottom tab has no icon.", error.message
  end

  test "a bottom tab with no iOS image is refused" do
    error = assert_raises(KeystoneUi::App::ShellCheck::Error) { check(bottom_tabs: [ tab(ios_system_image: nil) ]) }

    assert_equal "The Sales bottom tab has no iOS image.", error.message
  end

  test "a bottom tab with no Android icon is refused" do
    error = assert_raises(KeystoneUi::App::ShellCheck::Error) { check(bottom_tabs: [ tab(android_icon: nil) ]) }

    assert_equal "The Sales bottom tab has no Android icon.", error.message
  end

  test "a bottom tab naming a section that is not declared is refused, naming the tab and the section" do
    error = assert_raises(KeystoneUi::App::ShellCheck::Error) { check(bottom_tabs: [ tab(section: "Billing") ]) }

    assert_equal "The Sales bottom tab names the Billing section, which is not a declared navigation group.", error.message
  end

  private

  def check(bottom_tabs: [ tab ], native_rules: [], sections: [ "Sales" ])
    KeystoneUi::App::ShellCheck.new(bottom_tabs: bottom_tabs, native_rules: native_rules, sections: sections).call
  end

  def tab(**overrides)
    KeystoneUi::App::Configuration::BottomTab.new(label: "Sales", href: "/quotes", icon: "<svg></svg>", permitted: ->(_view) { true }, section: "Sales", ios_system_image: "cart", android_icon: "shopping_cart", **overrides)
  end
end
