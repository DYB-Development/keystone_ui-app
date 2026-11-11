# frozen_string_literal: true

module KeystoneUi
  module App
    class ShellCheck
      class Error < StandardError; end

      MOST_BOTTOM_TABS = 5

      def initialize(bottom_tabs:, native_rules:, sections:, app_areas: [])
        @bottom_tabs = bottom_tabs
        @app_areas = app_areas
        @native_rules = native_rules
        @sections = sections
      end

      def call
        @bottom_tabs.each.with_index(1) do |tab, position|
          raise Error, "Bottom tab #{position} has no label." if blank?(tab.label)
          raise Error, "The #{tab.label} bottom tab has no address." if blank?(tab.href)
          raise Error, "The #{tab.label} bottom tab has no icon." if blank?(tab.icon)
          raise Error, "The #{tab.label} bottom tab has no iOS image." if blank?(tab.ios_system_image)
          raise Error, "The #{tab.label} bottom tab has no Android icon." if blank?(tab.android_icon)
          raise Error, "The #{tab.label} bottom tab names the #{tab.section} section, which is not a declared navigation group." if tab.section && !@sections.include?(tab.section)
        end
        raise Error, "More than one bottom tab has the label #{shared_label}." if shared_label
        raise Error, "#{@bottom_tabs.size} bottom tabs are declared, and no more than #{MOST_BOTTOM_TABS} are allowed." if @bottom_tabs.size > MOST_BOTTOM_TABS
        @app_areas.each { |area| check_area(area) }
        raise Error, "More than one area covers the #{shared_group} group." if shared_group
        @native_rules.each.with_index(1) do |rule, position|
          raise Error, "Screen rule #{position} has no pattern." if Array(rule[:patterns]).all? { |pattern| blank?(pattern) }
        end
        nil
      end

      private

      def check_area(area)
        undeclared = area.groups.find { |group| !@sections.include?(group) }
        raise Error, "The #{area.name} area names the #{undeclared} group, which is not a declared navigation group." if undeclared
      end

      def shared_group
        @app_areas.flat_map { |area| area.groups.uniq }.tally.find { |_group, count| count > 1 }&.first
      end

      def shared_label
        @bottom_tabs.map(&:label).tally.find { |_label, count| count > 1 }&.first
      end

      def blank?(value)
        value.nil? || value.to_s.strip.empty?
      end
    end
  end
end
