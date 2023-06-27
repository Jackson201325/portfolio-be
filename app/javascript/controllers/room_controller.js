import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="room"
export default class extends Controller {
  static targets = ["bed_form", "bed_form_container"];

  addBed(e) {
    e.preventDefault();
    this.bed_form_containerTarget.insertAdjacentHTML(
      "beforeend",
      this.bed_formTarget.innerHTML
    );
  }
}
