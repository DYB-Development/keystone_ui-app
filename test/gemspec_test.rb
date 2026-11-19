# frozen_string_literal: true

require "test_helper"

class GemspecTest < ActiveSupport::TestCase
  def gemspec
    Gem::Specification.load(File.expand_path("../keystone_ui-app.gemspec", __dir__))
  end

  def requirement_for(name)
    gemspec.dependencies.find { |dependency| dependency.name == name }&.requirement
  end

  test "the gem requires a keystone_ui-styles that defines the hotwire-native variants" do
    assert_equal Gem::Requirement.new(">= 0.30.0"), requirement_for("keystone_ui-styles")
  end

  test "the gem requires a keystone_ui that lets it hide a navigation group from a person" do
    assert_equal Gem::Requirement.new(">= 0.104.0"), requirement_for("keystone_ui")
  end

  test "the packaged gem holds the importmap its engine pins" do
    assert_includes gemspec.files, "config/importmap.rb"
  end
end
