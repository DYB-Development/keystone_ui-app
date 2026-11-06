# frozen_string_literal: true

require "test_helper"

class JavascriptTest < ActiveSupport::TestCase
  ROOT = File.expand_path("..", __dir__)

  def read(path)
    File.read(File.join(ROOT, path))
  end

  test "the gem registers its native menu button controller under the name the shell draws" do
    assert_includes read("app/assets/javascripts/keystone_ui_app/index.js"), 'application.register("bridge--menu-button", MenuButtonController)'
  end
end
