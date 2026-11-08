import MenuButtonController from "keystone_ui_app/menu_button_controller"
import AddButtonController from "keystone_ui_app/add_button_controller"
import FormController from "keystone_ui_app/form_controller"

export function registerControllers(application) {
  application.register("bridge--menu-button", MenuButtonController)
  application.register("bridge--add-button", AddButtonController)
  application.register("bridge--form", FormController)
}

export { MenuButtonController, AddButtonController, FormController }
