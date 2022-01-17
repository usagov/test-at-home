require "rails_helper"
require "selenium/webdriver"

RSpec.describe "Person requests a test kit", type: :system do
  around do |example|
    ClimateControl.modify CACHE_FORM_AGE: "0" do
      example.run
    end
  end

  let(:smarty_response) do
    # San Francisco DMV
    [
      {
        input_index: 0,
        candidate_index: 0,
        delivery_line_1: "1377 Fell St",
        last_line: "San Francisco CA 94117-2224",
        delivery_point_barcode: "941172224774",
        components: {
          primary_number: "1377",
          street_name: "Fell",
          street_suffix: "St",
          city_name: "San Francisco",
          default_city_name: "San Francisco",
          state_abbreviation: "CA",
          zipcode: "94117",
          plus4_code: "2224",
          delivery_point: "77",
          delivery_point_check_digit: "4"
        },
        metadata: {
          record_type: "S",
          zip_type: "Standard",
          county_fips: "06075",
          county_name: "San Francisco",
          carrier_route: "C024",
          congressional_district: "12",
          rdi: "Commercial",
          elot_sequence: "0002",
          elot_sort: "A",
          latitude: 37.773335,
          longitude: -122.440468,
          coordinate_license: 1,
          precision: "Rooftop",
          time_zone: "Pacific",
          utc_offset: -8,
          dst: true
        },
        analysis: {
          dpv_match_code: "Y",
          dpv_footnotes: "AABB",
          dpv_cmra: "N",
          dpv_vacant: "N",
          dpv_no_stat: "N",
          active: "Y",
          footnotes: "B#"
        }
      }
    ]
  end

  before do
    stub_request(:get, /us-street.api.smartystreets.com/).to_return(status: 200, body: smarty_response.to_json, headers: {})
  end

  describe "with javascript enabled" do
    before do
      driven_by(:selenium_chrome_headless)
    end

    it "can request test and edit kit" do
      ClimateControl.modify DISABLE_SMARTY_STREETS_AUTOCOMPLETE: "true" do
        visit "/"

        fill_in "First name", with: "Kewpee"
        fill_in "Last name", with: "Doll"

        fill_in "Address Line 1", with: "1234 Fake St"
        fill_in "Address Line 2", with: "Apt 2"
        fill_in "City", with: "Lima"
        find(:xpath, "//button[contains(@aria-label, 'Toggle the dropdown list')]").click
        find("li", text: "OH - Ohio").click
        fill_in "Zip code", with: "12345"

        # Note: client-side address validations are currently silently failing in JS spec
        click_on "Review your order"

        expect(page).to have_content("Ship to")
        expect(page).to have_content("1234 Fake St")
        expect(page).to have_content("Apt 2")
        expect(page).to have_content("Lima, OH 12345")

        click_on "Edit"

        fill_in "Email", with: "real@example.com"

        click_on "Review your order"

        expect(page).to have_content("real@example.com")

        click_on "Place your order"

        expect(page).to have_content "Thank you, your order has been placed."
      end
    end

    context "when smarty streets disabled" do
      it "requires email" do
        ClimateControl.modify DISABLE_SMARTY_STREETS: "true", DISABLE_SMARTY_STREETS_AUTOCOMPLETE: "true" do
          visit "/"

          fill_in "First name", with: "Kewpee"
          fill_in "Last name", with: "Doll"

          fill_in "Address Line 1", with: "1234 Fake St"
          fill_in "Address Line 2", with: "Apt 2"
          fill_in "City", with: "Lima"
          find(:xpath, "//button[contains(@aria-label, 'Toggle the dropdown list')]").click
          find("li", text: "OH - Ohio").click
          fill_in "Zip code", with: "12345"

          click_on "Review your order"

          expect(page).to_not have_content("This step is optional")
          expect(page).to have_content("Please fill out this field")

          fill_in "Email", with: "real@example.com"

          click_on "Review your order"

          expect(page).to have_content("real@example.com")

          click_on "Place your order"

          expect(page).to have_content "Thank you, your order has been placed."

          assert_not_requested :any, /api.smartystreets.com/
        end
      end
    end
  end

  describe "with javascript disabled" do
    around do |example|
      # Recaptcha requires Javascript
      ClimateControl.modify RECAPTCHA_REQUIRED: "false" do
        example.run
      end
    end

    before do
      driven_by(:rack_test)
    end

    it "can still request test kit" do
      visit "/"

      fill_in "First name", with: "Kewpee"
      fill_in "Last name", with: "Doll"

      fill_in "Address Line 1", with: "1234 Fake St"
      fill_in "Address Line 2", with: "Apt 2"
      fill_in "City", with: "Lima"
      select "OH", from: "State"
      fill_in "Zip code", with: "12345"

      click_on "Place your order"

      expect(page).to have_content "Thank you, your order has been placed."
    end

    context "when smarty streets disabled" do
      it "requires email" do
        ClimateControl.modify DISABLE_SMARTY_STREETS: "true" do
          visit "/"

          fill_in "First name", with: "Kewpee"
          fill_in "Last name", with: "Doll"

          fill_in "Address Line 1", with: "1234 Fake St"
          fill_in "Address Line 2", with: "Apt 2"
          fill_in "City", with: "Lima"
          select "OH", from: "State"
          fill_in "Zip code", with: "12345"

          click_on "Place your order"

          expect(page).to have_content("Please fill out this field")
          fill_in "Email", with: "foo@example.com"
          select "OH", from: "State" # Re-select for now

          click_on "Place your order"

          expect(page).to have_content "Thank you, your order has been placed."

          assert_not_requested :any, /api.smartystreets.com/
        end
      end
    end

    context "when recaptcha disabled" do
      around do |example|
        # Recaptcha requires Javascript
        ClimateControl.modify RECAPTCHA_REQUIRED: "true" do
          example.run
        end
      end

      it "can still request test kit" do
        visit "/"

        fill_in "First name", with: "Kewpee"
        fill_in "Last name", with: "Doll"

        fill_in "Address Line 1", with: "1234 Fake St"
        fill_in "Address Line 2", with: "Apt 2"
        fill_in "City", with: "Lima"
        select "OH", from: "State"
        fill_in "Zip code", with: "12345"

        click_on "Place your order"

        expect(page).to have_content "Javascript is required. Please enable or try another browser."
      end
    end
  end
end
