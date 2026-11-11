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
  config.bottom_tab(label: "Home", href: "/", icon: HOME_ICON_SVG, permitted: ->(view) { view.user_signed_in? }, section: nil, ios_system_image: "house", android_icon: "home")
  config.bottom_tab(label: "Sales", href: ->(view) { view.main_app.quotes_path }, icon: ->(view) { view.render("icons/sales") }, permitted: ->(view) { view.user_signed_in? }, section: "Sales", ios_system_image: "cart", android_icon: "shopping_cart")
end
```

- `label:` is the text under the icon.
- `href:` is the address, either a string or a callable given the view.
- `icon:` is the icon's SVG markup, either a string or a callable given the view.
- `permitted:` is a callable given the view, and the tab is left out when it returns false.
- `section:` is the label of the keystone_ui navigation group the tab stands for, or `nil` for a tab that stands for none.
- `ios_system_image:` is the name of the SF Symbol the iOS app shows for the tab, such as `"house"`.
- `android_icon:` is the name of the icon the Android app shows for the tab, such as `"home"`.

A page that should show no bottom tabs calls `content_for :hide_bottom_tabs, true`.

## App areas

An app area is a part of the app that covers one or more keystone_ui navigation groups and gets one bottom tab. Declare the areas and the More page in the same initializer as the bottom tabs:

```ruby
KeystoneUi::App.configure do |config|
  config.bottom_tab(label: "Home", href: "/", icon: HOME_ICON_SVG, permitted: ->(view) { view.user_signed_in? }, section: nil, ios_system_image: "house", android_icon: "home")
  config.app_area(name: "Selling", description: "Quotes and orders", groups: [ "Sales" ], on_by_default: true, opens: :quotes, icon: ->(view) { view.render("icons/sales") }, ios_system_image: "cart", android_icon: "shopping_cart")
  config.more_page(href: ->(view) { view.main_app.more_path }, icon: MORE_ICON_SVG, ios_system_image: "ellipsis", android_icon: "more_horiz")
end
```

- `name:` is the area's name, and its tab is labelled with it.
- `description:` says what the area holds.
- `groups:` lists the labels of the keystone_ui navigation groups the area covers.
- `on_by_default:` says whether the area is on for an account, and until accounts can save a choice it decides for every account.
- `opens:` is the key of the navigation page the area's tab opens, and is optional.
- `icon:`, `ios_system_image:` and `android_icon:` are the tab's icons, given as a bottom tab's are.
- `more_page` declares the address of the app's More page and its tab's icons, and `href:` and `icon:` take a string or a callable given the view.

The bar on a phone shows, in this order:

1. The bottom tabs the person may see.
2. One tab for each area that is on and holds a page the person may open. The tabs follow the order the person saved for their navigation groups, each area in the place of its first group, or the order the areas are declared in when the person saved none.
3. A More tab, when the app declares a More page and the person may open a page that no tab in the bar opens.

The bar holds no more than five tabs, More included, and leaves out the areas that come last first. An area's tab opens the page `opens:` names when the person may open it, and otherwise the first page in the area the person may open, in their saved order. An area's tab is marked current on any page in one of its groups, and the More tab is marked current on the More page.

An app that declares no areas and no More page keeps the bar its bottom tabs give it.

## Boot check

The app refuses to boot when its bottom tabs, areas, More page or screen rules are declared wrong, and the error says which one:

- A bottom tab with no label, address, icon, iOS image or Android icon.
- A bottom tab whose `section:` is not the label of a declared keystone_ui navigation group.
- Two bottom tabs with the same label.
- More than five bottom tabs.
- A More page with more than four bottom tabs.
- An area with no tab icon, iOS image or Android icon.
- An area that names a group that is not a declared keystone_ui navigation group, named with the area.
- Two areas that cover the same group, named with the group.
- A screen rule with no pattern.

A tab with no label and a screen rule with no pattern are named by their position in the order they were declared, counting from 1.

## Page actions

On a phone browser a page puts its extra actions in the top bar, after the title, by filling one of three `content_for` blocks:

```erb
<%= ui_show_page(title: @invoice.number, back_url: invoices_path) %>
<% content_for :show_page_actions do %>
  <%= ui_action_menu_item(label: "Edit", href: edit_invoice_path(@invoice)) %>
  <%= ui_action_menu_item(label: "Delete", href: invoice_path(@invoice), method: :delete) %>
<% end %>
```

- `:show_page_actions` on a page drawn with `ui_show_page` shows an ellipsis button that opens a menu of what the block holds.
- `:form_page_action` on a page drawn with `ui_form_page` shows what the block holds, such as one link.
- `:mobile_action_menu` on any other page shows a plus button that opens a menu of what the block holds, for a page with several ways to add a record.

A page that fills none of them shows no action in the top bar. Each is hidden from the `lg` breakpoint up, where the page draws its own action buttons, and none is drawn inside the native app. A page header's single add action is drawn by keystone_ui's phone plus icon and the native add button, not by these blocks.

## Native add and submit buttons

Inside the native app, a page whose `ui_page_header` has an `action_url:` shows a plus button in the native nav bar with the action's label, and tapping it opens the action's page. A header that also passes `action_method: :post` makes the plus button post to the action's address, the same as its desktop button and its phone plus icon:

```erb
<%= ui_page_header(title: "Conversations", action_url: conversations_path, action_label: "New conversation", action_method: :post) %>
```

A form shows its submit button in the native nav bar when it takes its data from `ui_native_form_data`:

```erb
<%= ui_form(action: quotes_path, data: ui_native_form_data) do %>
  <%= ui_button(label: "Save") %>
<% end %>
```

Inside the native app the native button carries the title of the form's first submit button and submits the form when tapped. The web submit button is hidden. The native button cannot be tapped again until the submit ends. In a browser the form and its submit button are drawn as before.

The `bridge--add-button` and `bridge--form` controllers are registered by `registerControllers` with the gem's own copy of the Hotwire Native Bridge library, so the app pins no bridge library of its own.

## Native tabs and screen rules

The Hotwire Native apps read their tabs and screen rules from a path configuration the gem serves. Mount the engine at the root of the host's routes:

```ruby
mount KeystoneUi::App::Engine, at: "/"
```

That adds two addresses:

- `/hotwire/ios/path_configuration` serves the iOS app's configuration.
- `/hotwire/android/path_configuration` serves the Android app's configuration.

The controller behind them inherits from the host's `ApplicationController`, so a bottom tab's `permitted:` and `href:` callables are given a view with the host's helpers. The host keeps both addresses open to a person who is not signed in, since the native app reads them before sign-in.

Each configuration's `settings.tabs` holds the same tabs, in the same order, as the person's bar on a phone browser, with each tab's label as the title and its address as the path. The iOS app gets a list with each tab's `ios_system_image_name`. The Android app gets the same tabs with each tab's `icon`, encoded as one JSON string.

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
- On a phone browser, the page's actions after the title in the header: an ellipsis menu of a show page's `:show_page_actions`, a form page's `:form_page_action`, or a plus menu of another page's `:mobile_action_menu`. Inside the native app none of them is drawn.
- Inside the native app, the `menu-button` bridge component sends the section's label and tabs to the native menu button, and choosing a tab opens its page in place of the current one. A page in no section sends an empty list.
- Inside the native app, the `add-button` bridge component sends a page header's add action to the native plus button, and a page with no add action sends none.
- Inside the native app, a `style` element in the head that hides the web submit button of a form marked with `ui_native_form_data` once the native app has connected its `form` bridge component.
- Inside the native app, no navigation bar, no phone menus, no phone header and no footer, the `hotwire-native` class on the `html` element, and a viewport that cannot be pinch-zoomed.
- On a phone browser, keystone_ui's bottom nav at the foot of every page with the bottom tabs the person is permitted to see, then the tabs of the app's areas and the More tab as the App areas section says. The tab whose section, or whose area's groups, hold the current tab is marked as active. The bar is hidden from the `lg` breakpoint up, and is not drawn inside the native app, on a page that calls `content_for :hide_bottom_tabs, true`, or when the person may see none of the declared tabs.
- In a browser, the footer, unless the page calls `content_for :hide_footer, true`.

## Licence

MIT.
