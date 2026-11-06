# frozen_string_literal: true

require "test_helper"

class GemspecTest < ActiveSupport::TestCase
  def requirement_for(name)
    Gem::Specification.load(File.expand_path("../keystone_ui-app.gemspec", __dir__)).dependencies.find { |dependency| dependency.name == name }&.requirement
  end

  test "the gem requires a keystone_ui-styles that defines the hotwire-native variants" do
    assert_equal Gem::Requirement.new(">= 0.30.0"), requirement_for("keystone_ui-styles")
  end
end
