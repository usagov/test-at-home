// Entry point for the build script in your package.json
import "uswds";
import i18n from "i18n-js";

import { validateAddress } from "./helpers/addressValidation";
import { validateForm } from "./helpers/formValidation";

// DOM elements
const form = document.getElementById("form");
const submitButton = document.getElementById("submit-btn");
const formContainer = document.getElementById("form-cntr");
const reviewContainer = document.getElementById("review-cntr");
const privacyContainer = document.getElementById("privacy-cntr");
const editButton = document.getElementById("edit-btn");
const addressErrorContainer = document.getElementById("address-err-cntr");

// i18n strings
const reviewText = I18n.t("kit_requests.new.js.review");
const submitText = I18n.t("kit_requests.new.js.submit");
const emptyText = I18n.t("kit_requests.new.js.empty");
const invalidZipText = I18n.t("kit_requests.new.js.invalid.zip_code");

let isFormValid = false;

const handleFormValidation = async e => {
  if (validateForm.validateAll(e.target)) {
    const values = Object.entries(getFormValues(e.target));
    const address = getAddressValues(values);
    const res = await validateAddress(address);

    if (res.status === "valid") {
      addressErrorContainer.setAttribute("hidden", "");

      toggleContainer();

      values.forEach(
        ([key, value]) =>
          (getElement(key).innerHTML =
            key === "kit_request[email]" && !value
              ? `<span class="text-italic">${emptyText}</span>`
              : value)
      );

      isFormValid = true;
    } else {
      addressErrorContainer.innerHTML = res.message;
      addressErrorContainer.removeAttribute("hidden", "");
      addressErrorContainer.focus();

      isFormValid = false;
    }
  } else {
    isFormValid = false;
  }
};

const getAddressValues = values =>
  values.reduce((accum, [key, value]) => {
    accum[getSanitizedKey(key)] = value;

    return accum;
  }, {});

const getElement = key => {
  const id = getSanitizedKey(key);

  return document.getElementById(`review-${id}`);
};

const getSanitizedKey = key => key.match(/\[(.*?)\]/)[1];

const getFormValues = form => {
  const formData = new FormData(form);
  const entries = formData.entries();
  const { authenticity_token, ...data } = Object.fromEntries(entries);

  return data;
};

const hideReview = () => {
  toggleContainer();

  document
    .querySelectorAll('span[id^="review-"]')
    .forEach(element => (element.innerHTML = ""));

  isFormValid = false;
};

const showReview = async event => {
  event.preventDefault();

  if (isFormValid) event.target.submit();

  handleFormValidation(event);
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

// Check if JavaScript is enabled and form is present on page
if (window.uswdsPresent && form) {
  // Detect a successful form validation
  form.addEventListener("bouncerFormValid", showReview, false);

  // Update value of submit button to reflect review step
  submitButton.value = reviewText;

  // Hide privacy notice until review step
  privacyContainer.setAttribute("hidden", "");

  // Add listener to edit button
  editButton.addEventListener("click", hideReview, false);
}
