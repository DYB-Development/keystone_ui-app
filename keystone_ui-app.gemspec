require_relative "lib/keystone_ui/app/version"

Gem::Specification.new do |spec|
  spec.name = "keystone_ui-app"
  spec.version = KeystoneUi::App::VERSION
  spec.authors = [ "Tyler Schneider" ]
  spec.email = [ "tylercschneider@gmail.com" ]
  spec.homepage = "https://github.com/DYB-Development/keystone_ui-app"
  spec.summary = "The page frame for a Rails app built on Keystone UI."
  spec.description = "A companion engine for keystone_ui that draws a layout's page frame for desktop browsers, phone browsers and the Hotwire Native app from one call."
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"
  spec.metadata["documentation_uri"] = "#{spec.homepage}#readme"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.required_ruby_version = ">= 3.2.0"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,lib}/**/*", "MIT-LICENSE", "README.md"]
  end

  spec.add_dependency "keystone_ui", ">= 0.65.0"
  spec.add_dependency "keystone_ui-styles", ">= 0.30.0"
  spec.add_dependency "railties", ">= 7.0"
  spec.add_dependency "turbo-rails", ">= 2.0.20"
end
