// Entry point for the build script in your package.json

import "uswds";
import i18n from "i18n-js";
import Bouncer from "formbouncerjs";

// DOM elements
const form = document.getElementById("form");
const submitButton = document.getElementById("submit-btn");
const formContainer = document.getElementById("form-cntr");
const reviewContainer = document.getElementById("review-cntr");
const privacyContainer = document.getElementById("privacy-cntr");
const editButton = document.getElementById("edit-btn");

// i18n strings
const reviewText = I18n.t("kit_requests.new.js.review");
const submitText = I18n.t("kit_requests.new.js.submit");
const emptyText = I18n.t("kit_requests.new.js.empty");

// Initialize form validation library
const validate = new Bouncer("#form", {
  disableSubmit: true,
  messageTarget: "bouncerTarget",
  customValidations: {
    isValidZip: field => {
      if (!field.getAttribute("data-bouncer-is-valid-zip")) return false;

      return !/(^\d{5}$)|(^\d{5}-\d{4}$)/.test(field.value);
    }
  },
  messages: {
    isValidZip: "Please provide a valid zip code"
  }
});

const getElement = key => {
  const id = key.match(/\[(.*?)\]/);

  return document.getElementById(`review-${id[1]}`);
};

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
};

const showReview = ({ target }) => {
  if (reviewContainer.hasAttribute("hidden")) {
    toggleContainer();

    Object.entries(getFormValues(target)).forEach(
      ([key, value]) =>
        (getElement(key).innerHTML =
          key === "kit_request[email]" && !value
            ? `<span class="text-italic">${emptyText}</span>`
            : value)
    );
  } else {
    target.submit();
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

// Check if JavaScript is enabled and form is present on page
if (window.uswdsPresent && form) {
  // Detect a successful form validation
  document.addEventListener("bouncerFormValid", showReview, false);

  // Update value of submit button to reflect review step
  submitButton.value = reviewText;

  // Hide privacy notice until review step
  privacyContainer.setAttribute("hidden", "");

  // Add listener to edit button
  editButton.addEventListener("click", hideReview, false);
}
