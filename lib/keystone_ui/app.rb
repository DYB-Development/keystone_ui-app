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
      area_choices(view).on?(area_name)
    end

    def self.areas_open_to(view)
      groups = KeystoneUi.configuration.navigation_groups.select { |group| group.tabs_permitted_for(view).any? }.map(&:label)
      configuration.app_areas.select { |area| area.groups.intersect?(groups) }
    end

    def self.hide_turned_off_groups(navigation)
      navigation.hidden_group_supplier ||= ->(view, label) { group_turned_off?(view, label) }
    end

    def self.group_turned_off?(view, label)
      area = configuration.app_areas.find { |declared| declared.groups.include?(label) }
      area.present? && !area_on?(view, area.name)
    end

    def self.area_choices(view)
      env = view.request.env if view.respond_to?(:request)
      return AreaChoices.for(configuration, view) unless env

      env["keystone_ui_app.area_choices"] ||= AreaChoices.for(configuration, view)
    end

    def self.configure
      yield configuration
    end
  end
end
