import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "icon"]
  static values = { open: { type: Boolean, default: true } }

  connect() {
    this.render()
  }

  toggle() {
    this.openValue = !this.openValue
    this.render()
    
    // Save state to localStorage
    if (this.element.dataset.collapsibleKey) {
      localStorage.setItem(`collapsible:${this.element.dataset.collapsibleKey}`, this.openValue)
    }
  }

  render() {
    if (this.hasContentTarget) {
      this.contentTarget.classList.toggle("hidden", !this.openValue)
    }
    if (this.hasIconTarget) {
      this.iconTarget.style.transform = this.openValue ? "rotate(90deg)" : "rotate(0deg)"
    }
  }

  // Load saved state on connect
  openValueChanged() {
    if (this.element.dataset.collapsibleKey) {
      const saved = localStorage.getItem(`collapsible:${this.element.dataset.collapsibleKey}`)
      if (saved !== null) {
        this.openValue = saved === "true"
      }
    }
  }
}
