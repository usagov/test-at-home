import * as SmartyStreetsSDK from "smartystreets-javascript-sdk";
import i18n from "i18n-js";

// i18n strings
const addressNotFound = I18n.t("kit_requests.new.js.invalid.address_not_found");
const addressIncorrect = I18n.t(
  "kit_requests.new.js.invalid.address_incorrect"
);
const addressError = I18n.t("kit_requests.new.js.invalid.address_error");

const SmartyStreetsCore = SmartyStreetsSDK.core;
const Lookup = SmartyStreetsSDK.usStreet.Lookup;

const key = "115004691467527133"; // Embedded key for client side only
const credentials = new SmartyStreetsCore.SharedCredentials(key);

const clientBuilder = new SmartyStreetsCore.ClientBuilder(credentials)
  .withBaseUrl("https://us-street.api.smartystreets.com/street-address")
  .withLicenses(["us-core-cloud"]);

const client = clientBuilder.buildUsStreetApiClient();

function handleSuccess(response) {
  if (response.lookups[0].result.length) {
    const code = response.lookups[0].result[0].analysis.dpvMatchCode;

    if (["S", "Y"].some(validCode => validCode === code)) {
      return { status: "valid" };
    } else {
      if (code === "D") return { status: "invalid", message: addressIncorrect };

      return { status: "invalid", message: addressNotFound };
    }
  }

  return { status: "invalid", message: addressNotFound };
}

function handleError(response) {
  return { status: "error", message: addressError };
}

async function handleResponse(lookup) {
  try {
    const result = await client.send(lookup);

    return handleSuccess(result);
  } catch (err) {
    return handleError(err);
  }
}

const validateAddress = async address => {
  let lookup = new Lookup();

  lookup.street = address.mailing_address_1;
  lookup.secondary = address.mailing_address_2;
  lookup.city = address.city;
  lookup.state = address.state;
  lookup.zipCode = address.zip_code;
  lookup.maxCandidates = 1;
  lookup.match = "strict";

  return await handleResponse(lookup);
};

export { validateAddress };
