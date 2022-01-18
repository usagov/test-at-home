// Polyfills for IE support
import "core-js/stable";
import "regenerator-runtime/runtime";
import "promise-polyfill/src/polyfill";

import "uswds";
import i18n from "i18n-js";

import { autocomplete } from "./helpers/addressAutocomplete";
import { verifyAddress } from "./helpers/addressVerification";
import { validate } from "./helpers/validate";

// DOM elements
const form = document.getElementById("form");
const formContainer = document.getElementById("form-cntr");
const smartyHidden = document.getElementById("kit_request_js_smarty_status");

const addressAutocomplete = document.getElementById("address-autocomplete");
const addressErrorContainer = document.getElementById(
  "kit_request_mailing_address_error"
); // Generated from Rails
const addressFullContainer = document.getElementById("address-full-cntr");
const addressSimpleContainer = document.getElementById("address-simple-cntr");

const reviewContainer = document.getElementById("review-cntr");
const privacyContainer = document.getElementById("privacy-cntr");

const editButton = document.getElementById("edit-btn");
const submitButton = document.getElementById("submit-btn");
const recaptchaField = document.getElementById("g-recaptcha-response");

// I18n strings
const reviewText = I18n.t("js.review");
const submitText = I18n.t("js.submit");
const emptyText = I18n.t("js.empty");

// Initial form state
let isFormValid = false;
let prevAddress;

const clearValues = () => {
  addressFullContainer
    .querySelectorAll("input")
    .forEach(input => (input.value = ""));
};

const handleFormValidation = async ({ target }) => {
  if (validate.validateAll(target)) {
    const values = Object.entries(getFormValues(target));
    const address = getAddressValues(values);

    // If DISABLE_SMARTY_STREETS=true, skip address verification
    if (
      DISABLE_SMARTY_STREETS !== "true" &&
      JSON.stringify(address) !== prevAddress
    ) {
      const res = await verifyAddress(address);

      if (res.status === "valid") {
        addressErrorContainer.setAttribute("hidden", "");

        values.forEach(
          ([key, value]) =>
            (getElement(key).innerHTML =
              key === "kit_request[email]" && !value
                ? `<span class="text-italic">${emptyText}</span>`
                : value)
        );

        toggleContainer();

        isFormValid = true;
        prevAddress = JSON.stringify(address);
      } else {
        addressErrorContainer.innerHTML = res.message;
        addressErrorContainer.removeAttribute("hidden", "");
        addressErrorContainer.focus();

        isFormValid = false;
      }
    } else {
      values.forEach(
        ([key, value]) =>
          (getElement(key).innerHTML =
            key === "kit_request[email]" && !value
              ? `<span class="text-italic">${emptyText}</span>`
              : value)
      );

      toggleContainer();

      isFormValid = true;
    }
  } else {
    isFormValid = false;
  }
};

const getAddressValues = values =>
  values.reduce((accum, [key, value]) => {
    const newKey = getSanitizedKey(key);

    if (
      [
        "mailing_address_1",
        "mailing_address_2",
        "city",
        "state",
        "zip_code"
      ].includes(newKey)
    ) {
      accum[getSanitizedKey(key)] = value;
    }

    return accum;
  }, {});

const getElement = key =>
  document.getElementById(`review-${getSanitizedKey(key)}`);

const getSanitizedKey = key => key.match(/\[(.*?)\]/)[1];

const getFormValues = form => {
  const formData = new FormData(form);
  const entries = formData.entries();
  const {
    authenticity_token,
    commit,
    "input-autocomplete": autocomplete,
    "kit_request[js_smarty_status]": js_smarty_status,
    "kit_request[recaptcha_token]": recaptcha,
    ...data
  } = Object.fromEntries(entries);

  return data;
};

const hideReview = () => {
  toggleContainer();

  document
    .querySelectorAll('span[id^="review-"]')
    .forEach(element => (element.innerHTML = ""));

  isFormValid = false;
};

const showReview = event => {
  if (isFormValid) {
    smartyHidden.value = "pass";

    if (RECAPTCHA_REQUIRED === "true") {
      grecaptcha.enterprise.ready(function() {
        grecaptcha.enterprise
          .execute(RECAPTCHA_SITE_KEY, { action: "submit" })
          .then(function(token) {
            recaptchaField.value = token;
            event.target.submit();
          });
      });
    } else {
      event.target.submit();
    }
  } else {
    handleFormValidation(event);
  }
};

const toggleContainer = () => {
  // Scroll page to top to emulate page refresh
  window.scrollTo(0, 0);

  // Set visibility of container
  if (formContainer.hasAttribute("hidden")) {
    formContainer.removeAttribute("hidden", "");
    formContainer.querySelector("h1").focus();
    submitButton.value = reviewText;
    privacyContainer.setAttribute("hidden", "");
  } else {
    formContainer.setAttribute("hidden", "");
  }

  if (reviewContainer.hasAttribute("hidden")) {
    reviewContainer.removeAttribute("hidden", "");
    reviewContainer.querySelector("h1").focus();
    submitButton.value = submitText;
    privacyContainer.removeAttribute("hidden", "");
  } else {
    reviewContainer.setAttribute("hidden", "");
  }
};

if (form) {
  // Set up user interface
  submitButton.value = reviewText;
  privacyContainer.setAttribute("hidden", "");

  // If DISABLE_SMARTY_STREETS_AUTOCOMPLETE=true, remove autocomplete
  if (DISABLE_SMARTY_STREETS_AUTOCOMPLETE !== "true") {
    addressFullContainer.setAttribute("hidden", "");
    addressSimpleContainer.removeAttribute("hidden", "");
    addressAutocomplete.addEventListener("input", clearValues, false);
  } else {
    // Removes autocomplete input entirely so that it is not included
    // in form validation
    addressAutocomplete.remove();
  }

  // Detect a successful form validation
  form.addEventListener("bouncerFormValid", showReview, false);

  // Add listener to edit button
  editButton.addEventListener("click", hideReview, false);
}
