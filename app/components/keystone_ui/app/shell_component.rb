# frozen_string_literal: true

module KeystoneUi
  module App
    class ShellComponent < ViewComponent::Base
      renders_one :head
      renders_one :flash
      renders_one :logo
      renders_one :menus
      renders_one :footer
    end
  end
end
