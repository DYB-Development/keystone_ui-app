# frozen_string_literal: true

KeystoneUi.configure do |config|
  config.navigation_group("Sales") do |group|
    group.tab(:quotes, label: "Quotes", href: "/pages/plain?tab=quotes", permitted: ->(_view) { true })
    group.tab(:orders, label: "Orders", href: "/pages/plain?tab=orders", permitted: ->(_view) { true })
    group.tab(:refunds, label: "Refunds", href: "/pages/plain?tab=refunds", permitted: ->(_view) { false })
  end
  config.current_tab_supplier = ->(view) { view.params[:tab]&.to_sym }
end
