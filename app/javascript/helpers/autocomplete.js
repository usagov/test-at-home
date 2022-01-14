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

const handleConfirm = ({ city, secondary, state, streetLine, zipcode }) => {
  document.getElementById("kit_request_mailing_address_1").value = streetLine;
  document.getElementById("kit_request_mailing_address_2").value = secondary;
  document.getElementById("kit_request_city").value = city;
  document.getElementById("kit_request_state").value = state;
  document.querySelector("select[name='kit_request[state]']").value = state;
  document.getElementById("kit_request_zip_code").value = zipcode;
};

const handleRequest = async (lookup, lookupType) => {
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
      const res = await handleRequest(lookup);

      populateResults(res);
    },
    onConfirm: handleConfirm,
    templates: {
      inputValue: value => (value ? formatAddress(value) : ""),
      suggestion: value => (value ? formatAddress(value) : "")
    }
  });
