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
        end
        nil
      end

      private

      def blank?(value)
        value.nil? || value.to_s.strip.empty?
      end
    end
  end
end
