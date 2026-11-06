import MenuButtonController from "keystone_ui_app/menu_button_controller"

export function registerControllers(application) {
  application.register("bridge--menu-button", MenuButtonController)
}

export { MenuButtonController }
