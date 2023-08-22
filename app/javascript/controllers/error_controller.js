import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["main"]

  hideMessage() {
    // console.log("hideMessage")
    // console.log(this.mainTarget)
    //
    this.mainTarget.classList.add("opacity-0", "transition-opacity", "duration-500");

    // Add a delay before applying the "hidden" class again
    setTimeout(() => {
      this.mainTarget.classList.add("hidden");
    }, 500); // Adjust the delay duration as needed
  }
}
