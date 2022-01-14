import i18n from "i18n-js";
import Bouncer from "formbouncerjs";

const addressFullContainer = document.getElementById("address-full-cntr");

export const validate = new Bouncer("#form", {
  disableSubmit: true,
  messageTarget: "bouncerTarget",
  customValidations: {
    isValidZip: field => {
      if (!field.getAttribute("data-bouncer-is-valid-zip")) return false;

      return !/(^\d{5}$)|(^\d{5}-\d{4}$)/.test(field.value);
    }
  },
  messages: {
    isValidZip: I18n.t("js.invalid.zip_code"),
    missingValue: {
      select: I18n.t("js.invalid.missing_select"),
      default: I18n.t("js.invalid.missing_default")
    },
    patternMismatch: {
      email: I18n.t("js.invalid.email")
    }
  }
});
