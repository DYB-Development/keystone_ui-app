# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- On a phone browser a page that is not a form or show page shows the current section's name in the top bar with a menu of the section's tabs, the page's tab marked as active and tabs the person may not see left out.
- Inside the native app the `menu-button` bridge component sends the section's tabs to the native menu button, and choosing one opens its page in place of the current one.
- The engine pins its Stimulus controllers and a copy of Hotwire Native Bridge 1.2.2 in the host's importmap, and `registerControllers` from `keystone_ui_app/index` registers them.
- On a phone browser a page that calls `ui_page_header` shows the header's title in the top bar in place of the section's name.

### Changed
- The gem requires keystone_ui 0.65.0 or later, whose form page passes its subtitle to the phone header.
- The gem requires keystone_ui 0.66.0 or later, whose page header records its title for the top bar.

## [0.1.0] - 2026-11-06

### Added
- `ui_app_shell` draws a whole page from a layout, with the app's head, flash, logo, menus and footer in slots and the page inside a `main` element.
- The `html` element carries the light, dark or custom theme mode keystone_ui chooses for the person, and the current locale.
- On a desktop browser the page shows keystone_ui's navigation bar with the app's logo and menus.
- On a phone browser a form or show page shows keystone_ui's phone header with the back link, title and subtitle the page signals.
- Inside the Hotwire Native app the page shows no web navigation bar, no phone header and no footer.
- Inside the native app the `html` element carries the `hotwire-native` class, so every keystone_ui control marked `hotwire-native:hidden` is hidden.
- The shell writes the viewport meta tag, which lets a browser pinch-zoom the page and stops it inside the native app.
- A page in a browser shows the app's footer unless it calls `content_for :hide_footer, true`.
