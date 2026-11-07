# frozen_string_literal: true

module KeystoneUiAppHelper
  def ui_app_shell(body: {}, &block)
    render KeystoneUi::App::ShellComponent.new(body: body), &block
  end
end
