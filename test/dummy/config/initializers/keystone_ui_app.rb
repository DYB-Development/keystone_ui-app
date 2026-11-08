# frozen_string_literal: true

KeystoneUi::App.configure do |config|
  config.bottom_tab(label: "Home", href: "/pages/plain", icon: "<svg id='home-icon'></svg>", permitted: ->(_view) { true }, section: nil)
  config.bottom_tab(label: "Sales", href: "/pages/plain?tab=quotes", icon: "<svg id='sales-icon'></svg>", permitted: ->(_view) { true }, section: "Sales")
end
