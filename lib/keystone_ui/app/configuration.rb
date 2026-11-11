# frozen_string_literal: true

module KeystoneUi
  module App
    class Configuration
      BottomTab = Struct.new(:label, :href, :icon, :permitted, :section, :ios_system_image, :android_icon, keyword_init: true) do
        def href_for(view)
          href.respond_to?(:call) ? href.call(view) : href
        end

        def icon_for(view)
          icon.respond_to?(:call) ? icon.call(view) : icon
        end
      end

      AppArea = Struct.new(:name, :description, :groups, :on_by_default, :opens, :icon, :ios_system_image, :android_icon, keyword_init: true) do
        def icon_for(view)
          icon.respond_to?(:call) ? icon.call(view) : icon
        end
      end

      MorePage = Struct.new(:href, :icon, :ios_system_image, :android_icon, keyword_init: true) do
        def href_for(view)
          href.respond_to?(:call) ? href.call(view) : href
        end

        def icon_for(view)
          icon.respond_to?(:call) ? icon.call(view) : icon
        end
      end

      AccountLink = Struct.new(:label, :href, :permitted, :sign_out, keyword_init: true) do
        def href_for(view)
          href.respond_to?(:call) ? href.call(view) : href
        end
      end

      AccountPage = Struct.new(:href, keyword_init: true) do
        def href_for(view)
          href.respond_to?(:call) ? href.call(view) : href
        end
      end

      Notifications = Struct.new(:href, :unread_count, keyword_init: true) do
        def href_for(view)
          href.respond_to?(:call) ? href.call(view) : href
        end

        def unread_count_for(view)
          unread_count.respond_to?(:call) ? unread_count.call(view) : unread_count
        end
      end

      attr_reader :bottom_tabs, :app_areas, :more_page_tab, :account_links, :account_page_link, :notifications_link, :native_rules, :native_settings

      def initialize
        @bottom_tabs = []
        @app_areas = []
        @account_links = []
        @native_rules = []
        @native_settings = {}
      end

      def bottom_tab(label:, href:, icon:, permitted:, section:, ios_system_image: nil, android_icon: nil)
        @bottom_tabs << BottomTab.new(label: label, href: href, icon: icon, permitted: permitted, section: section, ios_system_image: ios_system_image, android_icon: android_icon)
      end

      def app_area(name:, description:, groups:, on_by_default:, icon:, ios_system_image:, android_icon:, opens: nil)
        @app_areas << AppArea.new(name: name, description: description, groups: groups, on_by_default: on_by_default, opens: opens, icon: icon, ios_system_image: ios_system_image, android_icon: android_icon)
      end

      def more_page(href:, icon:, ios_system_image:, android_icon:)
        @more_page_tab = MorePage.new(href: href, icon: icon, ios_system_image: ios_system_image, android_icon: android_icon)
      end

      def account_link(label:, href:, permitted:, sign_out: false)
        @account_links << AccountLink.new(label: label, href: href, permitted: permitted, sign_out: sign_out)
      end

      def account_page(href:)
        @account_page_link = AccountPage.new(href: href)
      end

      def notifications(href:, unread_count:)
        @notifications_link = Notifications.new(href: href, unread_count: unread_count)
      end

      def native_rule(patterns:, properties:)
        @native_rules << { patterns: patterns, properties: properties }
      end

      def native_setting(name, value)
        @native_settings[name] = value
      end
    end
  end
end
