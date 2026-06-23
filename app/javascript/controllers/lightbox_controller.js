import { Controller } from "@hotwired/stimulus"
import { Luminous } from "luminous-lightbox"
import "luminous-lightbox/dist/luminous-basic.css"

export default class extends Controller {
  static targets = ["trigger"]

  connect() {
    this.luminousInstances = this.triggerTargets.map(trigger => {
      return new Luminous(trigger, {
        caption: el => el.querySelector("img")?.alt || "",
        closeWithEscape: true,
      })
    })
  }

  disconnect() {
    this.luminousInstances?.forEach(l => l.destroy())
  }
}