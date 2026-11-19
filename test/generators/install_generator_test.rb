# frozen_string_literal: true

require "test_helper"
require "generators/keystone_ui/app/install/install_generator"

class KeystoneUi::App::InstallGeneratorTest < Rails::Generators::TestCase
  tests KeystoneUi::App::Generators::InstallGenerator
  destination File.expand_path("../../tmp/generators", __dir__)
  setup :prepare_destination

  test "the install generator adds the migration that creates the area choices table" do
    run_generator

    assert_migration "db/migrate/create_keystone_ui_app_area_choices.rb", /create_table :keystone_ui_app_area_choices/
  end
end
