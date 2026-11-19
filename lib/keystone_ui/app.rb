require "keystone_ui"
require "view_component"
require "turbo-rails"
require "keystone_ui/app/version"
require "keystone_ui/app/configuration"
require "keystone_ui/app/area_choices"
require "keystone_ui/app/engine"

module KeystoneUi
  module App
    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.area_on?(view, area_name)
      AreaChoices.new(configuration, account: configuration.account_supplier.call(view)).on?(area_name)
    end

    def self.configure
      yield configuration
    end
  end
end
