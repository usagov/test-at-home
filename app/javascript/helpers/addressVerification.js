import i18n from "i18n-js";

import * as SmartyStreetsSDK from "smartystreets-javascript-sdk";

const SmartyStreetsCore = SmartyStreetsSDK.core;
const Lookup = SmartyStreetsSDK.usStreet.Lookup;

// Embedded key for client side only
const key = SMARTY_STREETS_EMBEDDED_KEY;
const credentials = new SmartyStreetsCore.SharedCredentials(key);

const clientBuilder = new SmartyStreetsCore.ClientBuilder(
  credentials
).withLicenses(["us-core-custom-enterprise-cloud"]);

const client = clientBuilder.buildUsStreetApiClient();

// i18n strings
const addressNotFound = I18n.t("js.invalid.address_not_found");
const addressIncorrect = I18n.t("js.invalid.address_incorrect");

function handleSuccess(response) {
  if (response.lookups[0].result.length) {
    return { status: "valid" };
  }

  return { status: "invalid", message: addressNotFound };
}

function handleError(res) {
  // Assume there is a problem with the API and let
  // user proceed without client-side validations
  return { status: "valid" };
}

async function handleResponse(lookup) {
  try {
    const result = await client.send(lookup);

    return handleSuccess(result);
  } catch (err) {
    return handleError(err);
  }
}

export const verifyAddress = async address => {
  // If DISABLE_SMARTY_STREETS=true, skip address validation
  if (DISABLE_SMARTY_STREETS === "true") return { status: "valid" };

  let lookup = new Lookup();

  lookup.street = address.mailing_address_1;
  lookup.secondary = address.mailing_address_2;
  lookup.city = address.city;
  lookup.state = address.state;
  lookup.zipCode = address.zip_code;
  lookup.maxCandidates = 1;
  lookup.match = "enhanced";

  return await handleResponse(lookup);
};
