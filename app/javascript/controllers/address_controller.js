import { Controller } from "@hotwired/stimulus";

// google is a global function that will be available if the <script/> tag  in the application.html.erb load correctly
export default class extends Controller {
  static targets = [
    "input",
    "line1",
    "line2",
    "city",
    "state",
    "lat",
    "lng",
    "postal_code",
    "country",
  ];

  connect() {
    if (window.google) {
      this.initGoogle();
    }
  }

  initGoogle() {
    this.autocomplete = new google.maps.places.Autocomplete(this.inputTarget, {
      fields: ["address_components", "geometry"],
      types: ["address"],
    });

    this.autocomplete.addListener(
      "place_changed",
      this.placeSelected.bind(this)
    );
  }

  placeSelected() {
    const place = this.autocomplete.getPlace();

    if (!place.geometry) {
      return;
    }

    this.latTarget.value = place.geometry.location.lat();
    this.lngTarget.value = place.geometry.location.lng();

    // Get each component of the address from the place details,
    // and then fill-in the corresponding field on the form.
    // place.address_components are google.maps.GeocoderAddressComponent objects
    // which are documented at http://goo.gle/3l5i5Mr
    for (const component of place.address_components) {
      // @ts-ignore remove once typings fixed
      const componentType = component.types[0];

      switch (componentType) {
        case "street_number": {
          this.line1Target.value = `${component.long_name} ${this.line1Target.value}`;
          break;
        }

        case "route": {
          this.line1Target.value += component.short_name;
          break;
        }

        case "postal_code": {
          this.postal_codeTarget.value = `${component.long_name}${this.postal_codeTarget.value}`;
          break;
        }

        case "postal_code_suffix": {
          this.postal_codeTarget.value = `${this.postal_codeTarget.value}-${component.long_name}`;
          break;
        }

        case "locality":
          this.cityTarget.value = component.long_name;
          break;

        case "administrative_area_level_1": {
          this.stateTarget.value = component.short_name;
          break;
        }

        case "country": {
          this.countryTarget.value = component.short_name;
          break;
        }
      }
    }
  }
}
