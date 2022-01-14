// Entry point for the build script in your package.json
import "uswds";
import i18n from "i18n-js";

import { autocomplete } from "./helpers/autocomplete";
import { validate } from "./helpers/validate";

// DOM elements
const form = document.getElementById("form");
const submitButton = document.getElementById("submit-btn");
const formContainer = document.getElementById("form-cntr");
const addressFullContainer = document.getElementById("address-full-cntr");
const addressSimpleContainer = document.getElementById("address-simple-cntr");
const reviewContainer = document.getElementById("review-cntr");
const privacyContainer = document.getElementById("privacy-cntr");
const editButton = document.getElementById("edit-btn");
const addressErrorContainer = document.getElementById(
  "kit_request_mailing_address_error"
); // Generated from Rails

// I18n strings
const reviewText = I18n.t("js.review");
const submitText = I18n.t("js.submit");
const emptyText = I18n.t("js.empty");

// Initial form state
let isFormValid = false;

const handleFormValidation = ({ target }) => {
  if (validate.validateAll(target)) {
    toggleContainer();

    Object.entries(getFormValues(target)).forEach(
      ([key, value]) =>
        (getElement(key).innerHTML =
          key === "kit_request[email]" && !value
            ? `<span class="text-italic">${emptyText}</span>`
            : value)
    );

    isFormValid = true;
  } else {
    isFormValid = false;
  }
};

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

const showReview = event =>
  isFormValid ? event.target.submit() : handleFormValidation(event);

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

  // If DISABLE_SMARTY_STREETS=true, remove autocomplete
  if (process.env.DISABLE_SMARTY_STREETS !== "true") {
    addressFullContainer.setAttribute("hidden", "");
    addressSimpleContainer.removeAttribute("hidden", "");
  }

  // Detect a successful form validation
  form.addEventListener("bouncerFormValid", showReview, false);

  // Add listener to edit button
  editButton.addEventListener("click", hideReview, false);
}
