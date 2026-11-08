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

  test "the gem registers its native add button controller under the name the shell draws" do
    assert_includes read("app/assets/javascripts/keystone_ui_app/index.js"), 'application.register("bridge--add-button", AddButtonController)'
  end

  test "the gem registers its native submit button controller under the name a marked form carries" do
    assert_includes read("app/assets/javascripts/keystone_ui_app/index.js"), 'application.register("bridge--form", FormController)'
  end

  test "the engine's importmap pins every file the gem's controllers import" do
    pinned = read("config/importmap.rb").scan(/^pin "([^"]+)"/).flatten
    files = Dir[File.join(ROOT, "app/assets/javascripts/keystone_ui_app/*.js")].map { |file| "keystone_ui_app/#{File.basename(file, ".js")}" }

    assert_equal files.sort, pinned.sort
  end
end
