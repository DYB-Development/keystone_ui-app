# frozen_string_literal: true

require "keystone_ui/visible_navigation"
require "keystone_ui/app/bottom_bar"

module KeystoneUi
  module App
    class MorePageComponent < ViewComponent::Base
      Row = Struct.new(:label, :href, :pages, keyword_init: true)
      FRAME = "keystone-ui-app-more-page-list"

      def find
        helpers.params[:find].to_s.strip
      end

      def rows
        @rows ||= begin
          shown_areas = []
          visible_groups.filter_map do |group|
            area = area_holding(group.label)
            if group.standalone
              page_row(group.tabs.first)
            elsif area
              next if shown_areas.include?(area.name)

              shown_areas << area.name
              expandable_row(area.name, pages_of(area), href: bottom_bar.opened_href(area))
            else
              expandable_row(group.label, group.tabs)
            end
          end
        end
      end

      private

      def page_row(page)
        Row.new(label: page.label, href: page.href) if found(page.label)
      end

      def expandable_row(label, pages, href: nil)
        shown = found(label) ? pages : pages.select { |page| found(page.label) }
        Row.new(label: label, href: href, pages: shown.map { |page| { label: page.label, href: page.href } }) if shown.any?
      end

      def pages_of(area)
        visible_groups.select { |group| area.groups.include?(group.label) }.flat_map(&:tabs)
      end

      def area_holding(label)
        KeystoneUi::App.configuration.app_areas.find { |area| area.groups.include?(label) }
      end

      def found(text)
        find.empty? || text.to_s.downcase.include?(find.downcase)
      end

      def bottom_bar
        @bottom_bar ||= KeystoneUi::App::BottomBar.for(helpers)
      end

      def visible_groups
        @visible_groups ||= KeystoneUi::VisibleNavigation.new(
          KeystoneUi::App::PersonGroups.for(helpers).groups,
          view: helpers,
          saved_order: saved_order,
          current_tab: nil
        ).groups
      end

      def saved_order
        value = KeystoneUi.configuration.supplied_preference(helpers, :navigation)&.dig(:value)
        value.is_a?(Hash) && value["order"].is_a?(Array) ? value["order"] : []
      end
    end
  end
end
