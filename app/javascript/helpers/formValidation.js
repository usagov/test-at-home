import i18n from "i18n-js";
import Bouncer from "formbouncerjs";

const invalidZipText = I18n.t("kit_requests.new.js.invalid.zip_code");

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
    isValidZip: invalidZipText
  }
});

export { validateForm };
