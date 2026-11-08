# frozen_string_literal: true

module KeystoneUi
  module App
    class ShellCheck
      class Error < StandardError; end

      def initialize(bottom_tabs:, native_rules:, sections:)
        @bottom_tabs = bottom_tabs
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
        nil
      end

      private

      def shared_label
        @bottom_tabs.map(&:label).tally.find { |_label, count| count > 1 }&.first
      end

      def blank?(value)
        value.nil? || value.to_s.strip.empty?
      end
    end
  end
end
