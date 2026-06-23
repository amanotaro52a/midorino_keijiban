import { Application } from "@hotwired/stimulus"
import LightboxController from "./lightbox_controller"

const application = Application.start()

application.debug = false
window.Stimulus = application

application.register("lightbox", LightboxController)

export { application }