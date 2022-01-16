import i18n from "i18n-js";

import * as SmartyStreetsSDK from "smartystreets-javascript-sdk";
import accessibleAutocomplete from "accessible-autocomplete";

const SmartyStreetsCore = SmartyStreetsSDK.core;
const Lookup = SmartyStreetsSDK.usAutocompletePro.Lookup;

const key = process.env.SMARTY_STREETS_EMBEDDED_KEY;
const credentials = new SmartyStreetsCore.SharedCredentials(key);

const clientBuilder = new SmartyStreetsCore.ClientBuilder(
  credentials
).withLicenses(["us-autocomplete-pro-cloud"]);

const client = clientBuilder.buildUsAutocompleteProClient();

const element = document.querySelector("#address-autocomplete");

const handleConfirm = async value => {
  document.getElementById("kit_request_mailing_address_1").value =
    value.streetLine;
  document.getElementById("kit_request_mailing_address_2").value =
    value.secondary;
  document.getElementById("kit_request_city").value = value.city;
  document.getElementById("kit_request_state").value = value.state;
  document.querySelector("select[name='kit_request[state]']").value =
    value.state;
  document.getElementById("kit_request_zip_code").value = value.zipcode;
};

const handleRequest = async lookup => {
  try {
    const res = await client.send(lookup);

    return res.result;
  } catch (err) {
    console.log(err);
  }
};

const formatAddress = ({ streetLine, secondary, city, state, zipcode }) =>
  `${streetLine}${
    secondary ? `, ${secondary}` : ""
  }, ${city}, ${state} ${zipcode}`;

export const autoComplete =
  element &&
  accessibleAutocomplete({
    confirmOnBlur: false,
    element,
    id: "address-autocomplete",
    minLength: 6,
    required: true,
    source: async (query, populateResults) => {
      const lookup = new Lookup(query);
      lookup.maxResults = 4;
      lookup.source = "all";

      const res = await handleRequest(lookup);

      populateResults(res);
    },
    onConfirm: handleConfirm,
    templates: {
      inputValue: value => (value ? formatAddress(value) : ""),
      suggestion: value => (value ? formatAddress(value) : "")
    },
    tQueryTooShort: minQueryLength =>
      I18n.t("js.autocomplete.query_too_shot", { minQueryLength }),
    tNoResults: () => I18n.t("js.autocomplete.no_results"),
    tAssistiveHint: () => I18n.t("js.autocomplete.assistive_hint"),
    tSelectedOption: (selectedOption, length, index) =>
      I18n.t("js.autocomplete.selected_option", {
        selectedOption,
        length,
        index: index + 1
      }),
    tResults: (length, contentSelectedOption) => {
      const words = {
        result:
          length === 1
            ? I18n.t("js.autocomplete.result")
            : I18n.t("js.autocomplete.results"),
        is:
          length === 1
            ? I18n.t("js.autocomplete.is")
            : I18n.t("js.autocomplete.are")
      };
    }
  });