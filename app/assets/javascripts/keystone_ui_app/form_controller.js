import { BridgeComponent, BridgeElement } from "keystone_ui_app/hotwire_native_bridge"

export default class extends BridgeComponent {
  static component = "form"

  connect() {
    super.connect()
    const submitTitle = new BridgeElement(this.submitButton).title

    this.send("connect", { submitTitle }, () => {
      this.submitButton.click()
    })
  }

  get submitButton() {
    return this.element.querySelector("[type='submit']")
  }

  submitStart() {
    this.submitButton.disabled = true
    this.send("submitDisabled")
  }

  submitEnd() {
    this.submitButton.disabled = false
    this.send("submitEnabled")
  }
}
