import { BridgeComponent } from "keystone_ui_app/hotwire_native_bridge"

export default class extends BridgeComponent {
  static component = "add-button"
  static values = { url: String, label: String, method: String }

  connect() {
    super.connect()
    const data = { url: this.urlValue, label: this.labelValue }
    if (this.hasMethodValue) data.method = this.methodValue

    this.send("connect", data, () => {
      if (this.hasMethodValue) {
        this.submit()
      } else {
        window.Turbo.visit(this.urlValue)
      }
    })
  }

  submit() {
    const form = document.createElement("form")
    form.method = "post"
    form.action = this.urlValue
    form.hidden = true
    this.appendHidden(form, "authenticity_token", document.querySelector("meta[name='csrf-token']")?.content)
    if (this.methodValue !== "post") this.appendHidden(form, "_method", this.methodValue)
    document.body.appendChild(form)
    form.requestSubmit()
  }

  appendHidden(form, name, value) {
    if (!value) return

    const input = document.createElement("input")
    input.type = "hidden"
    input.name = name
    input.value = value
    form.appendChild(input)
  }
}
