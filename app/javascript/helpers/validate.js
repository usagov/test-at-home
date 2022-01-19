import i18n from "i18n-js";
import Bouncer from "formbouncerjs";

const addressFullContainer = document.getElementById("address-full-cntr");

export const validate = new Bouncer("#form", {
  disableSubmit: true,
  messageTarget: "bouncerTarget",
  customValidations: {
    addrSelected: field => {
      if (field.id !== "address-autocomplete") return false;
      if (
        Array.from(addressFullContainer.querySelectorAll("input", "select"))
          .filter(el => el.id !== "kit_request_mailing_address_2")
          .every(input => input.validity.valid)
      ) {
        return false;
      }

      return true;
    },
    isValidZip: field => {
      if (!field.getAttribute("data-bouncer-is-valid-zip")) return false;

      return !/(^\d{5}$)|(^\d{5}-\d{4}$)/.test(field.value);
    },
    emailLength: field => {
      if (!field.getAttribute("data-bouncer-email-length")) return false;

      return field.value.length >= 50;
    }
  },
  messages: {
    addrSelected: I18n.t("js.invalid.address_not_found"),
    isValidZip: I18n.t("js.invalid.zip_code"),
    emailLength: I18n.t("js.invalid.email_too_long"),
    missingValue: {
      select: I18n.t("js.invalid.missing_select"),
      default: I18n.t("js.invalid.missing_default")
    },
    patternMismatch: {
      email: I18n.t("js.invalid.email")
    }
  }
});
