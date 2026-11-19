# frozen_string_literal: true

require "delegate"

module KeystoneUi
  module App
    class PersonGroups
      ENV_KEY = "keystone_ui_app.person_groups"

      class Page < SimpleDelegator
        def initialize(page, view)
          super(page)
          @view = view
        end

        def count_for(_view)
          return @count if defined?(@count)

          @count = __getobj__.count_for(@view)
        end
      end

      class Group
        def initialize(group, view)
          @group = group
          @view = view
        end

        def label = @group.label

        def standalone? = @group.standalone?

        def tabs = @group.tabs

        def tabs_permitted_for(_view)
          @permitted ||= @group.tabs.select { |page| page.permitted.call(@view) }.map { |page| Page.new(page, @view) }
        end
      end

      def self.for(view)
        env = view.request.env if view.respond_to?(:request)
        return new(view) unless env

        env[ENV_KEY] ||= new(view)
      end

      attr_reader :groups

      def initialize(view)
        @groups = KeystoneUi.configuration.navigation_groups.map { |group| Group.new(group, view) }
      end
    end
  end
end
