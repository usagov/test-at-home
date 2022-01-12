import Bouncer from "formbouncerjs";

const validateForm = new Bouncer("#form", {
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

export { validateForm };
