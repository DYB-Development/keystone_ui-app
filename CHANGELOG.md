# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

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
