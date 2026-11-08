# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- `KeystoneUi::App.configure` takes `bottom_tab` declarations, each with a label, an address, an icon, a permission check and the navigation group it stands for.
- On a phone browser the shell draws the declared bottom tabs at the foot of every page, with the tab for the page's section marked as active and tabs the person may not see left out.
- The bottom tabs are not drawn inside the native app, on a page that calls `content_for :hide_bottom_tabs, true`, or when no tab is declared.
- A bottom tab takes an `ios_system_image:` and an `android_icon:` for the native apps' tab bars.
- Mounting the engine serves the Hotwire Native path configuration at `/hotwire/ios/path_configuration` and `/hotwire/android/path_configuration`, with one native tab for each bottom tab the person is permitted to see.
- Both native apps open new and edit pages as modals, and the Android app opens every other page in the web fragment.
- `KeystoneUi::App.configure` takes `native_rule` and `native_setting`, and both native apps receive the app's rules after the shipped rules and its settings beside the tabs.
- The app refuses to boot when a bottom tab has no label, address, icon, iOS image or Android icon, names a section that is not a declared navigation group, or shares its label with another tab, when more than five bottom tabs are declared, or when a screen rule has no pattern.
- Inside the native app a page whose header has an add action shows a plus button in the native nav bar that opens the action's page, or posts to it when the header passes `action_method:`.
- `ui_native_form_data` marks a form whose submit button the native app shows in its nav bar, and inside the native app the web submit button is hidden.
- While a marked form is submitting, its native submit button cannot be tapped again.
- `registerControllers` registers the `bridge--add-button` and `bridge--form` controllers.
- On a phone browser a show page that fills `content_for :show_page_actions` shows an ellipsis button in the top bar that opens a menu of those actions.
- On a phone browser a form page that fills `content_for :form_page_action` shows that action in the top bar.
- On a phone browser a page that fills `content_for :mobile_action_menu` shows a plus button in the top bar that opens a menu of those ways to add a record.
- Inside the native app none of a page's actions is drawn in the top bar.
- A page that fills none of the three blocks shows no action in the top bar.

### Changed
- The gem requires keystone_ui 0.69.0 or later, whose page header can mark its add action to post.

## [0.2.0] - 2026-11-07

### Added
- `ui_app_shell` takes `body:`, the attributes for the page's `body` element, and the body carries them.
- The `phone_menus` slot draws the app's menus at the top of the header on a phone browser, on every page including form and show pages, and inside the native app it is not drawn.
- The `html` element carries the `dark` class when the theme mode keystone_ui chooses for the person is dark.

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
- On a phone browser a page that is not a form or show page shows the current section's name in the top bar with a menu of the section's tabs, the page's tab marked as active and tabs the person may not see left out.
- Inside the native app the `menu-button` bridge component sends the section's tabs to the native menu button, and choosing one opens its page in place of the current one.
- The engine pins its Stimulus controllers and a copy of Hotwire Native Bridge 1.2.2 in the host's importmap, and `registerControllers` from `keystone_ui_app/index` registers them.
- On a phone browser a page that calls `ui_page_header` shows the header's title in the top bar in place of the section's name.
- The gem requires keystone_ui 0.66.0 or later, whose form page passes its subtitle to the phone header and whose page header records its title for the top bar.
