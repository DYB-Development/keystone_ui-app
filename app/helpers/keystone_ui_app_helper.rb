# frozen_string_literal: true

module KeystoneUiAppHelper
  def ui_app_shell(&block)
    render KeystoneUi::App::ShellComponent.new, &block
  end
end
