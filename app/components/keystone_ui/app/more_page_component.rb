# frozen_string_literal: true

module KeystoneUi
  module App
    class MorePageComponent < ViewComponent::Base
      Group = Struct.new(:label, :rows, keyword_init: true)

      def groups
        KeystoneUi.configuration.navigation_groups.map do |group|
          Group.new(label: group.label, rows: rows(group.tabs_permitted_for(helpers)))
        end.reject { |group| group.rows.empty? }
      end

      private

      def rows(pages)
        pages.map { |page| { label: page.label, href: page.href_for(helpers) } }
      end
    end
  end
end
