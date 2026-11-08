import MenuButtonController from "keystone_ui_app/menu_button_controller"
import AddButtonController from "keystone_ui_app/add_button_controller"

export function registerControllers(application) {
  application.register("bridge--menu-button", MenuButtonController)
  application.register("bridge--add-button", AddButtonController)
}

export { MenuButtonController, AddButtonController }
