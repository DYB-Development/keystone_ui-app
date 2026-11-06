import { BridgeComponent } from "keystone_ui_app/hotwire_native_bridge"

export default class extends BridgeComponent {
  static component = "menu-button"
  static values = { menu: Object }

  connect() {
    super.connect()
    this.send("connect", this.menuValue, (message) => {
      if (message.data.path) window.Turbo.visit(message.data.path, { action: "replace" })
    })
  }
}
