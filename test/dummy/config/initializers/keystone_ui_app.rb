# frozen_string_literal: true

KeystoneUi::App.configure do |config|
  config.bottom_tab(label: "Home", href: "/pages/plain", icon: "<svg id='home-icon'></svg>", permitted: ->(_view) { true }, section: nil)
  config.bottom_tab(label: "Sales", href: "/pages/plain?tab=quotes", icon: "<svg id='sales-icon'></svg>", permitted: ->(_view) { true }, section: "Sales")
  config.bottom_tab(label: "Refunds", href: "/pages/plain?tab=refunds", icon: "<svg></svg>", permitted: ->(_view) { false }, section: "Sales")
  config.bottom_tab(label: "Orders", href: ->(view) { "/pages/plain?tab=orders&from=#{view.request.path}" }, icon: ->(view) { view.tag.svg(id: "orders-icon") }, permitted: ->(_view) { true }, section: nil)
end
