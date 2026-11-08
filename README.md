# keystone_ui-app

The app shell for Rails apps built on keystone_ui. It draws the page frame for desktop browsers, phone browsers and the Hotwire Native app from one call in the layout.

## Install

```ruby
gem "keystone_ui"
gem "keystone_ui-app"
```

The gem requires keystone_ui-styles 0.30.0 or later, which defines the `hotwire-native` and `not-hotwire-native` Tailwind variants, and turbo-rails, whose `hotwire_native_app?` tells the shell it is inside the native app.

## Use

Replace the layout with one call to `ui_app_shell`, filling its slots and putting the page inside it:

```erb
<%= ui_app_shell(body: { data: { controller: "trail", trail_url_value: request.fullpath } }) do |shell| %>
  <% shell.with_head do %><%= render "head" %><% end %>
  <% shell.with_flash do %><%= render "flash" %><% end %>
  <% shell.with_logo do %><%= link_to "Shop", root_path %><% end %>
  <% shell.with_menus do %><%= render "user_menu" %><% end %>
  <% shell.with_phone_menus do %><%= render "phone_navbar" %><% end %>
  <% shell.with_footer do %><%= render "footer" %><% end %>
  <%= yield %>
<% end %>
```

Register the gem's Stimulus controllers beside keystone_ui's in `app/javascript/controllers/index.js`. The engine pins them in the importmap, along with its own copy of the Hotwire Native Bridge library:

```js
import { registerControllers as registerKeystoneUiAppControllers } from "keystone_ui_app/index"
registerKeystoneUiAppControllers(application)
```

`body:` takes the attributes for the page's `body` element, in the form `tag.body` takes them, such as the `data` attributes of the Stimulus controllers that read their settings from the body. It is optional.

Every slot is optional. The shell writes the `<!DOCTYPE html>`, the `html`, `head` and `body` elements and the viewport meta tag, so the app's head leaves out its own viewport tag.

## Bottom tabs

Declare the tabs for the bar at the foot of the page on a phone browser in an initializer. They are their own list, apart from keystone_ui's navigation groups:

```ruby
KeystoneUi::App.configure do |config|
  config.bottom_tab(label: "Home", href: "/", icon: HOME_ICON_SVG, permitted: ->(view) { view.user_signed_in? }, section: nil)
  config.bottom_tab(label: "Sales", href: ->(view) { view.main_app.quotes_path }, icon: ->(view) { view.render("icons/sales") }, permitted: ->(view) { view.user_signed_in? }, section: "Sales")
end
```

- `label:` is the text under the icon.
- `href:` is the address, either a string or a callable given the view.
- `icon:` is the icon's SVG markup, either a string or a callable given the view.
- `permitted:` is a callable given the view, and the tab is left out when it returns false.
- `section:` is the label of the keystone_ui navigation group the tab stands for, or `nil` for a tab that stands for none.
- `ios_system_image:` is the name of the SF Symbol the iOS app shows for the tab, such as `"house"`. It is optional.
- `android_icon:` is the name of the icon the Android app shows for the tab, such as `"home"`. It is optional.

A page that should show no bottom tabs calls `content_for :hide_bottom_tabs, true`.

## Native tabs and screen rules

The Hotwire Native apps read their tabs and screen rules from a path configuration the gem serves. Mount the engine at the root of the host's routes:

```ruby
mount KeystoneUi::App::Engine, at: "/"
```

That adds two addresses:

- `/hotwire/ios/path_configuration` serves the iOS app's configuration.
- `/hotwire/android/path_configuration` serves the Android app's configuration.

The controller behind them inherits from the host's `ApplicationController`, so a bottom tab's `permitted:` and `href:` callables are given a view with the host's helpers. The host keeps both addresses open to a person who is not signed in, since the native app reads them before sign-in.

Each configuration's `settings.tabs` holds one native tab for each bottom tab the person is permitted to see, with its label as the title and its address as the path. The iOS app gets a list with each tab's `ios_system_image_name`. The Android app gets the same tabs with each tab's `icon`, encoded as one JSON string.

Both configurations ship a rule that opens a page whose address ends in `/new` or `/edit` as a modal. The Android configuration also ships a rule before it that opens every page in the `hotwire://fragment/web` fragment with pull to refresh.

An app adds its own screen rules and settings in the initializer, and both native apps receive them. Its rules come after the shipped rules, and its settings sit beside `tabs`:

```ruby
KeystoneUi::App.configure do |config|
  config.native_rule(patterns: [ "/users/sign_in", "/users/sign_up" ], properties: { context: "modal" })
  config.native_setting(:require_authentication, false)
end
```

## What it draws

- The `html` element carries keystone_ui's theme attributes and the current locale.
- The `html` element carries the `dark` class when the theme mode keystone_ui chooses for the person is dark, and leaves it off for any other mode.
- The `body` element carries the attributes the layout passes as `body:`.
- On a desktop browser, keystone_ui's navigation bar with the logo and the menus.
- On a phone browser, the phone menus at the top of the header on every page, including form and show pages, inside an element hidden from the `lg` breakpoint up.
- On a phone browser, keystone_ui's phone header for a page drawn with `ui_form_page` or `ui_show_page`, with its back link, title and subtitle.
- On a phone browser, a page that is not a form or show page shows a menu of the current section's tabs, with the tab the page belongs to marked as active. The section is the navigation group holding the tab keystone_ui's current tab supplier names, and the menu leaves out tabs the person is not permitted to see. A page in no section shows no menu.
- Inside the native app, the `menu-button` bridge component sends the section's label and tabs to the native menu button, and choosing a tab opens its page in place of the current one. A page in no section sends an empty list.
- Inside the native app, no navigation bar, no phone menus, no phone header and no footer, the `hotwire-native` class on the `html` element, and a viewport that cannot be pinch-zoomed.
- On a phone browser, keystone_ui's bottom nav at the foot of every page with the tabs the app declares, leaving out tabs the person is not permitted to see. The tab whose section is the navigation group holding the current tab is marked as active. The bar is hidden from the `lg` breakpoint up, and is not drawn inside the native app, on a page that calls `content_for :hide_bottom_tabs, true`, or when the person may see none of the declared tabs.
- In a browser, the footer, unless the page calls `content_for :hide_footer, true`.

## Licence

MIT.
