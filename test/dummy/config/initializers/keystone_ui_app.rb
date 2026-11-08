# frozen_string_literal: true

KeystoneUi::App.configure do |config|
  config.bottom_tab(label: "Home", href: "/pages/plain", icon: "<svg id='home-icon'></svg>", permitted: ->(_view) { true }, section: nil, ios_system_image: "house", android_icon: "home")
  config.bottom_tab(label: "Sales", href: "/pages/plain?tab=quotes", icon: "<svg id='sales-icon'></svg>", permitted: ->(_view) { true }, section: "Sales", ios_system_image: "cart", android_icon: "shopping_cart")
  config.bottom_tab(label: "Refunds", href: "/pages/plain?tab=refunds", icon: "<svg></svg>", permitted: ->(_view) { false }, section: "Sales", ios_system_image: "arrow.uturn.backward", android_icon: "undo")
  config.bottom_tab(label: "Orders", href: ->(view) { "/pages/plain?tab=orders&from=#{view.request.path}" }, icon: ->(view) { view.tag.svg(id: "orders-icon") }, permitted: ->(_view) { true }, section: nil, ios_system_image: "shippingbox", android_icon: "inventory")
end
