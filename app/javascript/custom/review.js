module.exports = (function() {
  const form = document.getElementById("form");
  const submitButton = document.getElementById("submit-btn");
  const formContainer = document.getElementById("form-cntr");
  const reviewContainer = document.getElementById("review-cntr");
  const privacyContainer = document.getElementById("privacy-cntr");
  const editButton = document.getElementById("edit-btn");

  const reviewText = I18n.t("kit_requests.new.js.review");
  const submitText = I18n.t("kit_requests.new.js.submit");
  const emptyText = I18n.t("kit_requests.new.js.empty");

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

  const hideReview = e => {
    e.preventDefault();

    toggleContainer();

    Object.entries(getFormValues(e.target)).forEach(
      ([key, value]) => (getElement(key).innerHTML = "")
    );
  };

  const showReview = e => {
    if (reviewContainer.hasAttribute("hidden")) {
      e.preventDefault();

      toggleContainer();

      Object.entries(getFormValues(e.target)).forEach(
        ([key, value]) =>
          (getElement(key).innerHTML =
            key === "kit_request[email]" && !value
              ? `<span class="text-italic">${emptyText}</span>`
              : value)
      );
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

  // Check if JavaScript is enabled
  if (window.uswdsPresent) {
    // Update value of submit button to reflect review step
    submitButton.value = reviewText;

    // Hide privacy notice until review step
    privacyContainer.setAttribute("hidden", "");

    // Add listener to submit button
    if (submitButton) form.addEventListener("submit", showReview);

    // Add listener to edit button
    if (editButton) editButton.addEventListener("click", hideReview);
  }
})();
