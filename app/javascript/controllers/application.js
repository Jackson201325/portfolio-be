import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

// Create a event dispatcher for on load of google script
window.initMap = () => {
  const event = new Event("map-loaded")
  event.initEvent("map-loaded", true, true)
  window.dispatchEvent(event)
}

export { application }
