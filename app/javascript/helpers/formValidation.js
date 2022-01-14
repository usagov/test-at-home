import i18n from "i18n-js";
import Bouncer from "formbouncerjs";

const invalidZipText = I18n.t("js.invalid.zip_code");
const missingSelect = I18n.t("js.invalid.missing_select");
const missingDefault = I18n.t("js.invalid.missing_default");
const invalidEmail = I18n.t("js.invalid.email");

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
    isValidZip: invalidZipText,
    missingValue: {
      select: missingSelect,
      default: missingDefault
    },
    patternMismatch: {
      email: invalidEmail
    }
  }
});

export { validateForm };
