import { Application } from "@hotwired/stimulus"
import { Autocomplete } from "stimulus-autocomplete"
import LightboxController from "./lightbox_controller"
import PlantIdentifyController from "./plant_identify_controller"

const application = Application.start()
application.debug = false
window.Stimulus = application

application.register("autocomplete",   Autocomplete)
application.register("lightbox",       LightboxController)
application.register("plant-identify", PlantIdentifyController)

export { application }