import * as SmartyStreetsSDK from "smartystreets-javascript-sdk";
import accessibleAutocomplete from "accessible-autocomplete";

const SmartyStreetsCore = SmartyStreetsSDK.core;
const Lookup = SmartyStreetsSDK.usAutocompletePro.Lookup;

// Embedded key for client side only
const key = process.env.SMARTY_STREETS_EMBEDDED_KEY;
const credentials = new SmartyStreetsCore.SharedCredentials(key);

const clientBuilder = new SmartyStreetsCore.ClientBuilder(
  credentials
).withLicenses(["us-autocomplete-pro-cloud"]);

const client = clientBuilder.buildUsAutocompleteProClient();

async function handleRequest(lookup, lookupType) {
  try {
    const res = await client.send(lookup);

    return res.result.map(suggestion => suggestion.streetLine);
  } catch (err) {
    console.log(err);
  }
}

accessibleAutocomplete({
  element: document.querySelector("#address-cntr"),
  id: "kit_request_address",
  minLength: 6,
  source: async (query, populateResults) => {
    const lookup = new Lookup(query);
    const res = await handleRequest(lookup);

    populateResults(res);
  }
});
